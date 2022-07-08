Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C987256C0BD
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 20:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbiGHQiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 12:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238157AbiGHQiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 12:38:11 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C92167EF;
        Fri,  8 Jul 2022 09:38:10 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 9040A3200991;
        Fri,  8 Jul 2022 12:38:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 08 Jul 2022 12:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:message-id:mime-version:reply-to
        :sender:subject:subject:to:to; s=fm2; t=1657298287; x=
        1657384687; bh=KD3KK4qajRC4Z0kzf0DDUjxSr4hqLBOJDRxjLaucINg=; b=q
        vLxgIKuFC9yzKX461LjgdJMWMb9Xyo+11lTUGLsx2F9h/WCW6SY6oERYr0cRMVS0
        /Y4lvJssLCd0jg/a9xBGkHwLd/r0ustBBzr0WA/lGzEUtN+pZUw1xIeqIdWuuXKI
        vnViVizKvI3nB9OV7CZPngbOfxmPjKRQQKbDVuqOffWidX9wHysfk+IjBilaqAOS
        wDXLvoU3g3/RGOAJO0BvT1ztK4pBD+4bB3as/RE1PZaCZBwMfkAdDYLmVN3+Q4w4
        iyRv+nvZ7dd18s/kDKp4dCpZH/L8NF6BAhNSUQLCMP3JyfUvjSceTO05HIPlWh0e
        A1Aa4ljtr80IS2jcfN3cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1657298287; x=1657384687; bh=KD3KK4qajRC4Z0kzf0DDUjxSr4hqLBOJDRx
        jLaucINg=; b=AKODzjS5CvBQrpFFeAv2qZM719ZlgB3lopIVrjETHjrnhMgorr0
        q+Ku5nSW2FDeCpzXWgPBevNMkixlMzReBFcQdnQlLUU0RnTm50uveIqdTfdbF8+5
        WONajGkHTmt0avv/ql559heolfebQldp8Gqj1uml74rxFpBE3u66f4Wa7CDMuyua
        /RN3LELv+nSJNjMcMT5PxBCugeRikOBANDwORh1rpR+R/5hq3ILeCgEAIlfrs1VR
        lfeSD1k4YAoYVECEAOj8TtVXlFpI+v8dgMRfWK+redI21MGyClfG6Nf6QI8NZhsw
        lL8Egc87vJD1xU0gt7wdkExz2CPvnzXMn6w==
X-ME-Sender: <xms:bl3IYn5IDJYGgTjBdEBi85JdzLTy-2vVy79y4Z9162OUOj8hg_33Jw>
    <xme:bl3IYs4tekzTf_SETpKsx34JlBCtfWgeoi63Ya6L6JfcpZOauIhp2gH-Ck_7uuNhT
    L74S9NpJdFBaeQ>
X-ME-Received: <xmr:bl3IYufsdCpo6lfsBlL9gbo_BsPQXR2nqO4BocYxTvria27rAp_9SpRlhJ_mmPel-ZUXd0-LQJoU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeijedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffvghmihcu
    ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
    hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpedvfeegkedvkefgffegkefhieejtdff
    keehhfelheefjeeutefgleeggfdtveeileenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhgshhl
    rggsrdgtohhm
X-ME-Proxy: <xmx:bl3IYoLUdxxOo2wGKmFyCSCVq6iH_CKOnUKBUvcETebjFw2bFzQp3g>
    <xmx:bl3IYrILDqgnfPM0OYKRR9z9iFK-g92beucRh_UbyQWFD6x6FYjQMw>
    <xmx:bl3IYhyDe9EQUdmUNw4w1pkq2OOtWOD0h5XxQXShKd1FJzQRwBByVw>
    <xmx:b13IYj2wDvQEH5ebPkIBOC7ArFoi8yD04FHJ4979FfWWX-TiOyDoSQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Jul 2022 12:38:06 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Linux kernel regressions <regressions@lists.linux.dev>,
        stable@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Xen developer discussion <xen-devel@lists.xenproject.org>
Subject: gntdev warning fixes
Date:   Fri,  8 Jul 2022 12:37:44 -0400
Message-Id: <20220708163750.2005-1-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The recent gntdev fixes introduced two incorrect WARN_ON()s, which
triggered immediately on my system.  Patches for master and all
supported stable versions follow.


