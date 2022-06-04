Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E2753D65B
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 12:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiFDKH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 06:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiFDKH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 06:07:58 -0400
Received: from out20-62.mail.aliyun.com (out20-62.mail.aliyun.com [115.124.20.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCF817A9A
        for <stable@vger.kernel.org>; Sat,  4 Jun 2022 03:07:55 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2511257|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.0284828-0.00207937-0.969438;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047193;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.Nyy5TJY_1654337272;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.Nyy5TJY_1654337272)
          by smtp.aliyun-inc.com(33.38.168.42);
          Sat, 04 Jun 2022 18:07:53 +0800
Date:   Sat, 04 Jun 2022 18:07:56 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Greg KH <greg@kroah.com>
Subject: Re: drop 'exfat-fix-referencing-wrong-parent-directory-information-after-renaming.patch' please
Cc:     stable@vger.kernel.org, Yuezhang.Mo@sony.com,
        Namjae Jeon <linkinjeon@kernel.org>
In-Reply-To: <YpstbdUo+TNhSU1B@kroah.com>
References: <20220604091001.D570.409509F4@e16-tech.com> <YpstbdUo+TNhSU1B@kroah.com>
Message-Id: <20220604180755.3AAF.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.75.04 [en]
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> On Sat, Jun 04, 2022 at 09:10:02AM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > drop 'exfat-fix-referencing-wrong-parent-directory-information-after-renaming.patch' please.
> > 
> > When this patch is applied, the flowing xfstests/exfat become to fail.
> > - generic/011
> > - generic/013
> > - generic/028
> > - generic/035
> > and more.
> 
> Is there a fix for this in Linus's tree as well?
> 
> I'll go drop this from the stable trees now, thanks.
> 
> greg k-h

There is yet not a fix for this in Linus's tree(5.19).

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/06/04


