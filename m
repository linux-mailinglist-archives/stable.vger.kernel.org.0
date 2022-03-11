Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FCE4D6579
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 16:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348986AbiCKP7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 10:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiCKP7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 10:59:39 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47AD3FD82;
        Fri, 11 Mar 2022 07:58:33 -0800 (PST)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nShex-000B7l-5q;
        Fri, 11 Mar 2022 15:58:32 +0000
Message-ID: <86b4e961-3c17-3544-ee1e-b69b0c8417b5@youngman.org.uk>
Date:   Fri, 11 Mar 2022 15:58:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-GB
To:     Wilson Jonathan <i400sjon@gmail.com>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <0d4088b987437788846b7d69879189f4870b90c6.camel@gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <0d4088b987437788846b7d69879189f4870b90c6.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/03/2022 11:30, Wilson Jonathan wrote:
> I have no idea why the speed of the "check" would seemingly affect the
> apparent responsiveness of the computer and why it would appear that
> the slower the check the slower the responsiveness.

The buffers were filling up, nicking your free ram, and you were having 
to wait longer and longer before they could be flushed to swap your 
applications back in?

Cheers,
Wol
