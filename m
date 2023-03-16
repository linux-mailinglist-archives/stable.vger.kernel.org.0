Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226386BC38A
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 03:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCPCBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 22:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjCPCBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 22:01:44 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F01BB5FE9;
        Wed, 15 Mar 2023 19:01:41 -0700 (PDT)
X-QQ-mid: bizesmtp69t1678932083t9enazw6
Received: from [10.4.16.24] ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 16 Mar 2023 10:01:22 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: HPkwb3INVpCkD+eN/AbJL1aye0ngp8ExXZNAlsIxfdcXhygZjrvR7Vi7OvtGI
        WSIbE5OF+UDpoXSfmatWabhKHemR+EtxsGJnlWoodLK/J0zsVD0vI4SyCEY47qKHTNZYgIw
        N+K59owGBp3Kh7YLarR5XTV2nRPDrpysFSj2TYE6pVvKyvsPatUw5e2I56CD+9qZRZ0tM+i
        vWVyKw+1Dltcm0L5je8TyBhs/OhyqR6QCl7S7QCTGbGLu0zeNCd5vqrzo2fg7K+PeIctVDj
        TVXJrye+CorIGApY7aSqCi7/CL13fmWoXQbj39ratlDeagNK9KTPIYI7ux4+zygoVD+Ge2I
        EoNKjho8378i1xNGuzc48yLAi/nXQipRV4mgaT7idoLyooG7SKWIMaa3Hspyw==
X-QQ-GoodBg: 1
Message-ID: <927A9CC7D19E5BD6+6758c124-1a86-a981-d3cf-fa0da9ab589e@uniontech.com>
Date:   Thu, 16 Mar 2023 10:01:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [REGRESSION] External mic not working on Lenovo Ideapad U310,
 ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model
To:     Takashi Iwai <tiwai@suse.de>, Jetro Jormalainen <jje-lxkl@jetro.fi>
Cc:     regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230308215009.4d3e58a6@mopti> <87o7ou9jfi.wl-tiwai@suse.de>
From:   tangmeng <tangmeng@uniontech.com>
In-Reply-To: <87o7ou9jfi.wl-tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2023/3/15 22:29, Takashi Iwai wrote:

> 
> Sounds like multiple models using the same PCI SSID.
> Could you share the alsa-info.sh output?
> Meng, also could you give alsa-info.sh output of Lenovo 20149, too?
> 
> 
Sorry, because the environment used before belongs to the customer's 
environment, the environment has been returned to the customer after the 
verification is completed.
Output information is no longer available.

