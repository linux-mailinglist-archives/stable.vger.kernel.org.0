Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9744E576533
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 18:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiGOQXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 12:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiGOQXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 12:23:15 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A744B6EEAA
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 09:23:14 -0700 (PDT)
Received: from [10.10.132.123] (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id 6724F40755C7;
        Fri, 15 Jul 2022 16:23:09 +0000 (UTC)
Message-ID: <1de5cd3e-50a5-ae25-f328-95ccf6ceaefb@ispras.ru>
Date:   Fri, 15 Jul 2022 19:23:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 1/3] docs: net: explain struct net_device lifetime
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
References: <20220714161134.95034-1-pchelkin@ispras.ru>
 <20220714161134.95034-2-pchelkin@ispras.ru> <YtF14wpR9oBeb8dI@kroah.com>
From:   Fedor Pchelkin <pchelkin@ispras.ru>
In-Reply-To: <YtF14wpR9oBeb8dI@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 > If you pass on patches to others, you also must sign off on them.
Sorry. I've fixed that for all the patches.

I also found out that the previous series was incomplete. It solved the
use-after-free bug but produced a new one. It turns out that several
more patches are required in order to fully solve this problem.

 > And why is a documentation patch needed for stable?
I think the documentation patch is needed because it safely fixes a docs 
file section on the issue and a comment fragment. It is important for 
consistency because that docs patch describes the problem and gives more 
clarity to the code, and it was included in the original patch series as 
well.

Fedor
