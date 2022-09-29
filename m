Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4285EF825
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 16:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbiI2O6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 10:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235740AbiI2O6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 10:58:50 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28ED149786;
        Thu, 29 Sep 2022 07:58:47 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 28TEwT1O008324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Sep 2022 10:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1664463511; bh=XdnqQwti8MU8K4U7XKcxgq3p/hXMwfXFEDlPznxZawg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=G9+cMlJeGYN9ep/h9QScFQAOrkK48RUrtpt2tnKdc1mNGoTEU1NbtKoBC/e5jmv3S
         unEiy8+piDiF+wYwfqHhm/i1v7S+azIC0f84PaDGuEybl4k96+QrgxS+ZWLySgcK9q
         RWCUWxGYnlxtws+AiPEy3JuocJEJCuWll7fwWApgOwxKXbKZQHt39L4nQIAaXrrPbS
         C+MTn2fibXhWThZZxBcvacr0vf+ZbYLIccbW5AvJNwUt3UkBvd5orb2IvmW14vB71+
         U+f+xTjfwD1Af1p9JQ9RdJDK9Af8wG5kUGtdPkXukw1IdUtJJ36BEwDqoeIeWUkCB3
         BlTTIFfc9MRMQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 754E115C00C9; Thu, 29 Sep 2022 10:58:29 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     jack@suse.cz
Cc:     "Theodore Ts'o" <tytso@mit.edu>, carnil@debian.org,
        linux-ext4@vger.kernel.org, lczerner@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix check for block being out of directory size
Date:   Thu, 29 Sep 2022 10:58:23 -0400
Message-Id: <166446350048.149484.14790223647442624434.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220822114832.1482-1-jack@suse.cz>
References: <20220822114832.1482-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Aug 2022 13:48:32 +0200, Jan Kara wrote:
> The check in __ext4_read_dirblock() for block being outside of directory
> size was wrong because it compared block number against directory size
> in bytes. Fix it.
> 
> 

Applied, thanks!

[1/1] ext4: Fix check for block being out of directory size
      commit: 013c07e4705fb994e5e56530af0bc6272884b5c1

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
