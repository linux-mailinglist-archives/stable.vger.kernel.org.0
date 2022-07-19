Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814F057A138
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 16:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiGSOVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 10:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241040AbiGSOPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 10:15:15 -0400
Received: from fallback10.mail.ru (fallback10.mail.ru [94.100.178.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A165C9D2;
        Tue, 19 Jul 2022 06:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail4;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From:References:Cc:To:MIME-Version:Date:Message-ID:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=CRBN72BnqLaUFGlmTev/x3CCPB3ATH+NWQkCFmsQTuU=;
        t=1658238159;x=1658328159; 
        b=p8ziAqjykKf/xmdUSwUejcn6UqGslxDi+ktj4I3CEqahkpkcedLSQClptf5wlQ71ZHeUFitNlrm5IXmWqi9/u97xfcBglYCBUm8Gebd0pJBb2lPDo+BDOb12bdWd3MQ1BC2GDa0AtFMxhcXChphefkbqbm2usgCuMndSyJxcIfwT3ieIZSjRydx4jm4u9pH8Sn8dcZuhhTwNZUaonxAHW06es7k0KHKEAe+lt7xUQh/p6+47abjhZ90/j9N7NB3QDxHG9r2yUtYqbtCdvv5kE7PD6x8tTsmI3k+LVUsb97opSn4IGUYetqKCs077FfT7PhOxDpUjJZAk4j65oY96jA==;
Received: from [10.161.64.47] (port=58280 helo=smtp39.i.mail.ru)
        by fallback10.m.smailru.net with esmtp (envelope-from <joey.corleone@mail.ru>)
        id 1oDnUj-0001cd-6O; Tue, 19 Jul 2022 16:42:37 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail4;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From:References:Cc:To:MIME-Version:Date:Message-ID:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=CRBN72BnqLaUFGlmTev/x3CCPB3ATH+NWQkCFmsQTuU=;
        t=1658238157;x=1658328157; 
        b=Pl6fdkRO63tcRIME0gvAF2bo1vL/q47gagEfB6hvAvd+IbPZiay31BH/bP9KWaRrpzyACrk8DcWOHWcoMKcsQ8ehDbyU003hu6xq9DZr2ys3UG9MmT8ZMR8StCQetlbWZhuOw8h2b71l/18KGysDxa6gosaAVA8uwoL69zUMB2K+JsMfOE3pP1ymjTMk8bOSNsr5z52oG/2y7vMzQfrC9GdE1q+QP+zzGSRbE8q9SM2Lp/UvisgdQZ0h4roCDy7IkeV/2uWim5DjGOU9Xp6hiW8305V0lT5alM6I2HTdMyfKFdOu7hdezTfhieQF1LC9TT4Ay8XMTWVIcxPVJSxTlQ==;
Received: by smtp39.i.mail.ru with esmtpa (envelope-from <joey.corleone@mail.ru>)
        id 1oDnUZ-0002di-UJ; Tue, 19 Jul 2022 16:42:28 +0300
Message-ID: <fe4005ed-802a-d276-a6c8-87717d16c089@mail.ru>
Date:   Tue, 19 Jul 2022 15:42:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev
References: <20220623111945.1557702-1-mathias.nyman@linux.intel.com>
 <20220623111945.1557702-3-mathias.nyman@linux.intel.com>
From:   Joey Corleone <joey.corleone@mail.ru>
Subject: Re: [PATCH 2/4] xhci: turn off port power in shutdown
In-Reply-To: <20220623111945.1557702-3-mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailru-Src: smtp
X-7564579A: EEAE043A70213CC8
X-77F55803: 4F1203BC0FB41BD910A510B04B6817B6F106AEB2F97A1EDD9BFA8A287B205D79182A05F5380850404C228DA9ACA6FE27AAB74C16A6DFC1EEF85461E69ED777E7DA17E07BC4F14BB82BDB2C35E9FAD4E3
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE73A0E02362971E860EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F790063702DFA59B3C994360EA1F7E6F0F101C6723150C8DA25C47586E58E00D9D99D84E1BDDB23E98D2D38B8859CA687ABA27BABABF9FC33778379A28279B337D4E93C320879F7C8C5043D14489FFFB0AA5F4BF176DF2183F8FC7C0CB629EEF1311BF91D2E47CDBA5A96583C09775C1D3CA48CFB8679471DAEB8BD5117882F4460429724CE54428C33FAD30A8DF7F3B2552694AC26CFBAC0749D213D2E47CDBA5A9658378DA827A17800CE709B92020B71E24959FA2833FD35BB23DF004C90652538430302FCEF25BFAB3454AD6D5ED66289B5278DA827A17800CE7ED9CAD6087716A5DD32BA5DBAC0009BE395957E7521B51C20BC6067A898B09E4090A508E0FED62991661749BA6B97735DCBB792301359AD2CD04E86FAF290E2D7E9C4E3C761E06A71DD303D21008E29813377AFFFEAFD269A417C69337E82CC2E827F84554CEF50127C277FBC8AE2E8BA83251EDC214901ED5E8D9A59859A8B614C86A7F3C0C55A4089D37D7C0E48F6C5571747095F342E88FB05168BE4CE3AF
X-8FC586DF: 6EFBBC1D9D64D975
X-C1DE0DAB: 9604B64F49C60606AD91A466A1DEF99B296C473AB1E142185AC9E3593CE4B31AB1881A6453793CE9274300E5CE05BD4401A9E91200F654B0DDDEAE67FA777B9C4B91265EEBC6D5971AA9AA36BD7595A34E8D97600880E3129C2B6934AE262D3EE7EAB7254005DCED8DA55E71E02F9FC08E8E86DC7131B365E7726E8460B7C23C
X-C8649E89: 4E36BF7865823D7055A7F0CF078B5EC49A30900B95165D34C6EC1BD9807109D22BF9009A3E84BCFE634F7FDAFF5FFECFEA196E74581334496026C4B894FFD2351D7E09C32AA3244CEABB4712C59D05305EED2CAC6731CDECB4DF56057A86259F83B48618A63566E0
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojIQnzJ/fIPDav+9Et+nj6gg==
X-Mailru-Sender: DED7486378921B4FC0A8FE1DA3DEB3E5EAB3514B12F35D8E8CBBA87860A96DF225C4B44B058F942BC7BD54E8F9380F2338FA998476DAE4F3C2C748B250BAC47DFBB808E5A3D83AADCC0C6A881B01D7986DAEE9A828B31F4FEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: Ok
X-7564579A: 646B95376F6C166E
X-77F55803: 6242723A09DB00B4BD2EB812D5A6E5F73100061528378235B97A9710EB1729B1049FFFDB7839CE9E01BDCB885458B1974532F44544BDFE837D51B0FB2BA73E66BBACE75B92701110
X-7FA49CB5: 0D63561A33F958A5BFDC63617B12B35043EC29EE52C58BDD9C7B89EE89DE46ADCACD7DF95DA8FC8BD5E8D9A59859A8B6FF43116A1C2F940DCC7F00164DA146DAFE8445B8C89999728AA50765F790063781612DB815465C93389733CBF5DBD5E9C8A9BA7A39EFB766F5D81C698A659EA7CC7F00164DA146DA9985D098DBDEAEC886D40F53BA192295F6B57BC7E6449061A352F6E88A58FB86F5D81C698A659EA73AA81AA40904B5D9A18204E546F3947C08214CF94FAA95E0040F9FF01DFDA4A84AD6D5ED66289B52698AB9A7B718F8C442539A7722CA490CD5E8D9A59859A8B6E893544302A799B3EFF80C71ABB335746BA297DBC24807EABDAD6C7F3747799A
X-C1DE0DAB: 9604B64F49C60606AD91A466A1DEF99B296C473AB1E142185AC9E3593CE4B31AB1881A6453793CE9274300E5CE05BD44CFFBF5018520E398671AA518CC42EA904B91265EEBC6D5974908109C68FCCC7667F98FEC4960AB0D9C2B6934AE262D3EE7EAB7254005DCED8DA55E71E02F9FC08E8E86DC7131B365E7726E8460B7C23C
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojIQnzJ/fIPDYpikmjvOWReQ==
X-Mailru-MI: 8000000000000800
X-Mras: Ok
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.06.22 13:19, Mathias Nyman wrote:
> If ports are not turned off in shutdown then runtime suspended
> self-powered USB devices may survive in U3 link state over S5.
> 
> During subsequent boot, if firmware sends an IPC command to program
> the port in DISCONNECT state, it will time out, causing significant
> delay in the boot time.
> 
> Turning off roothub port power is also recommended in xhci
> specification 4.19.4 "Port Power" in the additional note.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>   drivers/usb/host/xhci-hub.c |  2 +-
>   drivers/usb/host/xhci.c     | 15 +++++++++++++--
>   drivers/usb/host/xhci.h     |  2 ++
>   3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
> index c54f2bc23d3f..0fdc014c9401 100644
> --- a/drivers/usb/host/xhci-hub.c
> +++ b/drivers/usb/host/xhci-hub.c
> @@ -652,7 +652,7 @@ struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd)
>    * It will release and re-aquire the lock while calling ACPI
>    * method.
>    */
> -static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
> +void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
>   				u16 index, bool on, unsigned long *flags)
>   	__must_hold(&xhci->lock)
>   {
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index cb99bed5f755..65858f607437 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -791,6 +791,8 @@ static void xhci_stop(struct usb_hcd *hcd)
>   void xhci_shutdown(struct usb_hcd *hcd)
>   {
>   	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
> +	unsigned long flags;
> +	int i;
>   
>   	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
>   		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
> @@ -806,12 +808,21 @@ void xhci_shutdown(struct usb_hcd *hcd)
>   		del_timer_sync(&xhci->shared_hcd->rh_timer);
>   	}
>   
> -	spin_lock_irq(&xhci->lock);
> +	spin_lock_irqsave(&xhci->lock, flags);
>   	xhci_halt(xhci);
> +
> +	/* Power off USB2 ports*/
> +	for (i = 0; i < xhci->usb2_rhub.num_ports; i++)
> +		xhci_set_port_power(xhci, xhci->main_hcd, i, false, &flags);
> +
> +	/* Power off USB3 ports*/
> +	for (i = 0; i < xhci->usb3_rhub.num_ports; i++)
> +		xhci_set_port_power(xhci, xhci->shared_hcd, i, false, &flags);
> +
>   	/* Workaround for spurious wakeups at shutdown with HSW */
>   	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
>   		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
> -	spin_unlock_irq(&xhci->lock);
> +	spin_unlock_irqrestore(&xhci->lock, flags);
>   
>   	xhci_cleanup_msix(xhci);
>   
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 0bd76c94a4b1..28aaf031f9a8 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -2196,6 +2196,8 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
>   int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
>   int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
>   struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
> +void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
> +			 bool on, unsigned long *flags);
>   
>   void xhci_hc_died(struct xhci_hcd *xhci);
>   

fyi: there is a report [1] about a regression introduced by this patch.

Joey

[1] https://bugzilla.kernel.org/show_bug.cgi?id=216243
