Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DFA55D533
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiF0FyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 01:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiF0FyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 01:54:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C52D2DC3;
        Sun, 26 Jun 2022 22:54:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B74F9CE112F;
        Mon, 27 Jun 2022 05:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A66C341C8;
        Mon, 27 Jun 2022 05:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656309245;
        bh=Sus3/9KJFbCudnP5NL9Wq/YGxqU1cqKDlw/yXzz/byE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PmnyKU2R6B3OwWkNwA71Bb3W4yu3aSzlU4JKpSGEYVhtUVgjXPiWii2v775TAVKXH
         71qSOmGElh9zC6RSYT5QQRe4TkLChzhb4joLhhlzKZVtuPRAInPSRc5/29vrUHxJJQ
         l6JnTSuBl/ebjvoqtCkynONE2ZRG51fMWyWayEE0=
Date:   Sun, 26 Jun 2022 22:54:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Junxiao Bi <junxiao.bi@oracle.com>
Cc:     "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "piaojun@huawei.com" <piaojun@huawei.com>,
        "mark@fasheh.com" <mark@fasheh.com>,
        "joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>,
        "jlbec@evilplan.org" <jlbec@evilplan.org>,
        "heming.zhao@suse.com" <heming.zhao@suse.com>,
        "ghe@suse.com" <ghe@suse.com>,
        "gechangwei@live.cn" <gechangwei@live.cn>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: + revert-ocfs2-mount-shared-volume-without-ha-stack.patch added
 to mm-hotfixes-unstable branch
Message-Id: <20220626225404.e12f34eb4d416c6e6184f9bf@linux-foundation.org>
In-Reply-To: <0D22B946-B3D7-4137-BC22-2737CA00D92A@oracle.com>
References: <20220626202113.CE8DAC34114@smtp.kernel.org>
        <0D22B946-B3D7-4137-BC22-2737CA00D92A@oracle.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 26 Jun 2022 23:18:44 +0000 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Thanks for merging it to mm.
> I see the “From” is “ Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>”, can you help fix that?

Thanks, I fixed that.
