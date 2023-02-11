Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8C6693104
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 13:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjBKMm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 07:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBKMm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 07:42:28 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834D2360B1;
        Sat, 11 Feb 2023 04:42:27 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pQpCz-00029B-Jj; Sat, 11 Feb 2023 13:42:25 +0100
Message-ID: <b74b2c93-bd0b-84c2-868b-d5376a16b020@leemhuis.info>
Date:   Sat, 11 Feb 2023 13:42:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US, de-DE
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <git-mailbomb-linux-master-690eb7dec72ae52d1d710d14a451844b4d0f4f19@kernel.org>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Cc:     Bastien Nocera <hadess@hadess.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Heads-up: one change merged for -rc8 that might be good to have in
 the next 6.1.y release
In-Reply-To: <git-mailbomb-linux-master-690eb7dec72ae52d1d710d14a451844b4d0f4f19@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1676119347;7ca394f6;
X-HE-SMSGID: 1pQpCz-00029B-Jj
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg. Would be great if you could pick up 690eb7dec72a ("HID:
logitech: Disable hi-res scrolling on USB") for the next 6.1.y release,
as it's fixing a regression I saw multiple people report.

The commit (see below) that was recently merged to mainline and has a
proper stable "Cc: <stable@...>" tag, so I guess you scripts will at
some point pick it up automatically. But I noticed you updated the
stable queue and hour ago and this patch afaics is not in it yet
(despite some other patches being in it that were merged later), so I
thought: just to be sure send a quick heads up.

Ciao, Thorsten

On 09.02.23 19:10, Linux Kernel Mailing List wrote:
> Commit:     690eb7dec72ae52d1d710d14a451844b4d0f4f19
> Parent:     ea427a222d8bdf2bc1a8a6da3ebe247f7dced70c
> Refname:    refs/heads/master
> Web:        https://git.kernel.org/torvalds/c/690eb7dec72ae52d1d710d14a451844b4d0f4f19
> Author:     Bastien Nocera <hadess@hadess.net>
> AuthorDate: Fri Feb 3 11:18:00 2023 +0100
> Committer:  Benjamin Tissoires <benjamin.tissoires@redhat.com>
> CommitDate: Mon Feb 6 10:58:15 2023 +0100
> 
>     HID: logitech: Disable hi-res scrolling on USB
>     
>     On some Logitech mice, such as the G903, and possibly the G403, the HID
>     events are generated on a different interface to the HID++ one.
>     
>     If we enable hi-res through the HID++ interface, the HID interface
>     wouldn't know anything about it, and handle the events as if they were
>     regular scroll events, making the mouse unusable.
>     
>     Disable hi-res scrolling on those devices until we implement scroll
>     events through HID++.
>     
>     Signed-off-by: Bastien Nocera <hadess@hadess.net>
>     Tested-by: Tobias Klausmann <klausman@schwarzvogel.de>
>     Link: https://bugzilla.kernel.org/show_bug.cgi?id=216885
>     Fixes: 908d325e1665 ("HID: logitech-hidpp: Detect hi-res scrolling support")
>     Cc: stable@vger.kernel.org
>     Link: https://lore.kernel.org/r/20230203101800.139380-1-hadess@hadess.net
>     Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/hid-logitech-hidpp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> index abf2c95e4d0b0..9c1ee8e91e0ca 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -3978,7 +3978,8 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
>  	}
>  
>  	hidpp_initialize_battery(hidpp);
> -	hidpp_initialize_hires_scroll(hidpp);
> +	if (!hid_is_usb(hidpp->hid_dev))
> +		hidpp_initialize_hires_scroll(hidpp);
>  
>  	/* forward current battery state */
>  	if (hidpp->capabilities & HIDPP_CAPABILITY_HIDPP10_BATTERY) {
> 
