Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2666952C9B3
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 04:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiESCRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 22:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiESCRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 22:17:04 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235D387A02;
        Wed, 18 May 2022 19:17:03 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24J2GwFI023172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 22:16:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1652926619; bh=yO0392GK1Lza0inKxpdctFuIMKpGhWBtmh7/KllmqtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=U+iSXLVfgcH4mIyrAtileid1m6qt0vHv/SzfN2xOylCervVFRRXxlTWnbL9twIIE1
         +hFWZI148kTW/qXDi6MDn508HIlGXtaLt60gUhlSwZUfcQ0d26Dc63nxB85ihc+duP
         g+B+VijVajDo1mIb3Om5mzIRPv9pWXS0OCUhaJcvJOyLNZeEizNFI+ms1gtJGH45qp
         yL6F5bFsNHbpCnV7WcB6a/Wq8qZD+NEYsraFWxg4VeESeavbckpcKQOoMaMgruT216
         GjLFu5scoCY7XPpgmJrC2ZOoAtb3is6FgO52HYDewdEtBU41lNMasrCYRYrsSlZP7L
         EVi0wTme9YOfw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id ED83A15C3EC0; Wed, 18 May 2022 22:16:57 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: Verify dir block before splitting it
Date:   Wed, 18 May 2022 22:16:57 -0400
Message-Id: <165292657448.1203635.6416779693628113818.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220518093332.13986-1-jack@suse.cz>
References: <20220518093143.20955-1-jack@suse.cz> <20220518093332.13986-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 18 May 2022 11:33:28 +0200, Jan Kara wrote:
> Before splitting a directory block verify its directory entries are sane
> so that the splitting code does not access memory it should not.
> 
> 

Applied, thanks!

[1/2] ext4: Verify dir block before splitting it
      commit: dfd094204c1f5bb4b1772bade3769cc92b645f1b
[2/2] ext4: Avoid cycles in directory h-tree
      commit: 01db66b58446cd7372c4f29324d270b4cd15157d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
