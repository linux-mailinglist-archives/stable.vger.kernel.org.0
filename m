Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482DE65624B
	for <lists+stable@lfdr.de>; Mon, 26 Dec 2022 12:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLZL5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Dec 2022 06:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiLZL5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Dec 2022 06:57:47 -0500
X-Greylist: delayed 444 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 26 Dec 2022 03:57:46 PST
Received: from serv15.avernis.de (serv15.avernis.de [176.9.89.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A0925FA
        for <stable@vger.kernel.org>; Mon, 26 Dec 2022 03:57:46 -0800 (PST)
Received: from webmail.serv15.avernis.de (ip6-localhost [IPv6:::1])
        by serv15.avernis.de (Postfix) with ESMTPSA id A8407BDE8929;
        Mon, 26 Dec 2022 12:50:15 +0100 (CET)
MIME-Version: 1.0
Date:   Mon, 26 Dec 2022 11:50:15 +0000
From:   Andreas Ziegler <br015@umbiko.net>
To:     Slade Watkins <srw@sladewatkins.net>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: rtla osnoise hist: average duration is always zero
In-Reply-To: <CA+pv=HO1mvnN5XZHkWDjWr=NJHJZxjcstiY4qtJGJ6mfsqPfQw@mail.gmail.com>
References: <d7bb31547e9bbf6684801a7bbd857810@umbiko.net>
 <CA+pv=HO1mvnN5XZHkWDjWr=NJHJZxjcstiY4qtJGJ6mfsqPfQw@mail.gmail.com>
Message-ID: <a900f403176c0e806051efc0f34f2912@umbiko.net>
X-Sender: br015@umbiko.net
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.7 at serv15.avernis.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-12-24 21:17, Slade Watkins wrote:
> On Sat, Dec 24, 2022 at 7:48 AM Andreas Ziegler <br015@umbiko.net> 
> wrote:
>> 
>> -- Observed in, but not limited to, Linux 6.1.1
> 
> Wait, "but not limited to"? What does that mean? Are there more
> versions affected?

This was meant to indicate that the bug is not a regression; it can be 
found in every release since introduction in 5.17. Currently affected 
are 6.1.y and 6.0.y kernel trees.

Regards,
Andreas

> -- Slade
