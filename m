Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42174F0117
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 13:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240549AbiDBLbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 07:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiDBLbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 07:31:33 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8296549FA9
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 04:29:41 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 524EE5C0178;
        Sat,  2 Apr 2022 07:29:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 02 Apr 2022 07:29:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=/OlFFkBC2nrKPs4QNTWMChjivYAAtT1HZ8cZIU
        YvhvQ=; b=M5WrVd0u6aGslWAJjCffO5Au0WNvSMXpaKdjJrdxH8RCCknouFEsrt
        TkCerLqt90Dudy1dKIyuEmN9i4enVFbbWyflCl47pIWBnUWNBg1IaSNIIMqdbNeY
        EhpPF/FS3OOWNOOOPPT51SRvaGL9HfLdgGe1997LOkZCsjjoDcdgcHfY6fU/IbSe
        a3G/8N34kk2DGsx9bZXmP4353tp9zTZnMRjr7D6Bi/rP0nfuaLBZ6cA3+b1Ig9qE
        aO8QnfLmK4ot+DWjhR+3nSqAPGWqNQ3NDpw4oYqathaIwAgMSbB7y5k00uyzevBD
        3NI31j52pSxZuMLUSgRApPTClyzm9Hmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/OlFFkBC2nrKPs4QN
        TWMChjivYAAtT1HZ8cZIUYvhvQ=; b=j83WRSP2TrSwkjt6vIa3blv057IcFiBJb
        D3waD2g63YWlXzH7qdTd3mWwfDKfumZgd48ydI6JX0EI7QgxsADnEU9GVvhOGGbV
        jHJcQa+LiYkn92nBN/34zBtW+iUKy0FSLQ9lvy051ysbqPTfQ8DXGJjlWd3rnVXO
        l7RH6kvbLog1nR2V2HjguewQdO1Z9kQvpo5J9JUXEN4V6GH3CU4k2UAgH7oJSZ+8
        nmXY3gTUJymbcqf4PyPlaV+gPcFkhMKW2tTST7wqB3YouZUhwPA999DEWc+2aRnf
        YVCyIK1TfGJKwtT6AsXbbF8mPi8mxU34RZqMJPt9VC9lgtroYECtA==
X-ME-Sender: <xms:ojNIYr1PghWHea74Yf1MowUSajL9yI-vRjAy9Sb_njW7LCACiGwatQ>
    <xme:ojNIYqHdUeyc7gavVZf-HsJmHm-KBnTqcEykrE3JGpCAuQE5OPWOm5cy2VpHN0g9d
    GUQfGFUiqY9Qg>
X-ME-Received: <xmr:ojNIYr5bxhGy905n2DDDuN_-rByz-PbZwe_eycYJbyq0d_olt4fMned-icdeCDrn1AnrUV3_B5nUnkiXYMSPB_5Ak6cvrBet>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeikedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeelhefhje
    eltdegleevgeeuueduhfejtdehfedvkeektdejfeehheejiedtveehgeenucffohhmrghi
    nhepuggvnhigrdguvgdpkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ojNIYg0w7WM_l9mNBuXIdUyz0K_8_AboBNt8AC7ErDt2TKR8uxmk2A>
    <xmx:ojNIYuHnaHPvylwt4pXuYmUIfUDTTCL316FlmU_Mz22rMToqBmNhIw>
    <xmx:ojNIYh99UcZ0ERXC-_odL8r-x6TOdbseVCE80i0EXNKJcUAZjLmpfA>
    <xmx:ojNIYsav2xmYPe7D2eONDSO8xshl61Qx9vkzBr5XEqSGN6fpGxyDjA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 2 Apr 2022 07:29:37 -0400 (EDT)
Date:   Sat, 2 Apr 2022 13:29:35 +0200
From:   Greg KH <greg@kroah.com>
To:     Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Cc:     stable@vger.kernel.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: Re: [PATCH for v5.15+] PCI: fu740: Force 2.5GT/s for initial device
 probe
Message-ID: <Ykgzn+uwwWWgTwDS@kroah.com>
References: <20220331115345.117662-1-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331115345.117662-1-dimitri.ledkov@canonical.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 12:53:45PM +0100, Dimitri John Ledkov wrote:
> From: Ben Dooks <ben.dooks@codethink.co.uk>
> 
> commit a382c757ec5ef83137a86125f43a4c43dc2ab50b upstream.
> 
> The fu740 PCIe core does not probe any devices on the SiFive Unmatched
> board without this fix (or having U-Boot explicitly start the PCIe via
> either boot-script or user command). The fix is to start the link at
> 2.5GT/s speeds and once the link is up then change the maximum speed back
> to the default.
> 
> The U-Boot driver claims to set the link-speed to 2.5GT/s to get the probe
> to work (and U-Boot does print link up at 2.5GT/s) in the following code:
> https://source.denx.de/u-boot/u-boot/-/blob/master/drivers/pci/pcie_dw_sifive.c?id=v2022.01#L271
> 
> Link: https://lore.kernel.org/r/20220318152430.526320-1-ben.dooks@codethink.co.uk
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
> ---
> 
>  Please apply this patch to v5.15+ stable trees which fixes PCIe on
>  the very popular SiFive Unmatched RISC-V board.
> 
>  drivers/pci/controller/dwc/pcie-fu740.c | 51 ++++++++++++++++++++++++-
>  1 file changed, 50 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
