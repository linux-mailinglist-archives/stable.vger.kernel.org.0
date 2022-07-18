Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E79B578941
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 20:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbiGRSJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 14:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235772AbiGRSJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 14:09:01 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8826A25D3;
        Mon, 18 Jul 2022 11:08:57 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 21D715C0138;
        Mon, 18 Jul 2022 14:08:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 18 Jul 2022 14:08:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:message-id:mime-version:reply-to
        :sender:subject:subject:to:to; s=fm3; t=1658167734; x=
        1658254134; bh=Q+2bcuYbqNaeJUyXlpoGM3BHR0EjVdzO4fH/v0jEPL4=; b=K
        FkuLtwY8N/NT+897LsnwrmqResDCTsmeNkRGz3A4D3IKhIHhReJBdgxGEoglt8lz
        t61FyVx/GsuH6AmhqZ38839vURcVrFYkv20tkQA9jQ5vR7f9QOJA/SkanhWDmA/y
        GuPLaciVjfUAlMPq211+3XLfQ/HQ9vXP28mLMjidgW6pDnDwC6Os9AXFyBKoRe9m
        1vm1GymUnpzZXWpVKRbd3jn21WapiKGr+flz0RH8GnbITVf/OsnazMtkyxCfSOzO
        7+UCRRjYB9C7iCYUbRGNiNF0+izwCTRXjuyJ1OfleorZjNzEZuis1qV0RwX2A4+J
        5HWGgeTxZZKdLpOJL1uZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1658167734; x=1658254134; bh=Q+2bcuYbqNaeJUyXlpoGM3BHR0EjVdzO4fH
        /v0jEPL4=; b=lSA5Fe4ygcts/JbmilaClF0qUDFhO1v8zGlO49buFQIxkpBkCjc
        McN43T2+kEcMDKdVPi+JvNpeculuYe+NotAGpPd2mM8IAsfZHnMhvDlJhYQ0sGXg
        W3r8+p6wO47FwElGock0/nexZQPlWbC4sQ6+iUHnhbxtjVjHOn0w1SKR7jAFqBzQ
        ETeQrynfaCoi0n5T0ZbbMTMGCDt5yPOScnZt0FUHgDOtciZMET5eFGWTaKygc0AM
        Dlj/KIiQw11ksh9R9o49qAvzbJwNI3EC4dzbAXyxBUG9Wt/tsZjGNsC8IYplR2Vq
        qIcixAAgWOGO7Oi7uG+btMtCxr2ucmlxNUw==
X-ME-Sender: <xms:taHVYgtMQ3kYUFAQnvD9lZE1lxr_UhG6qcwc-qhVvaohVVk08IWVdw>
    <xme:taHVYtdeEwQ54v2429QhTfR5nf78vQqQmrQjh6yuWWzYEBGFsEimaJDy7XmzeH1rV
    u_1stTrvLcpvLs>
X-ME-Received: <xmr:taHVYrzjCPu7tnDLwcDjp_xU4Ntl3q9-yyZgQe8T1YzFC6DTX8o5idZm2oFGW_9Ucgzyiku9L6zQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekkedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffvghmihcu
    ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
    hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpedvfeegkedvkefgffegkefhieejtdff
    keehhfelheefjeeutefgleeggfdtveeileenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhgshhl
    rggsrdgtohhm
X-ME-Proxy: <xmx:taHVYjNLlx0_FeAaJcGGVzoa88tuX6WwtfCAZz2kOT25UO-_-clsHw>
    <xmx:taHVYg-bQlA-ljX_ZuBG063vbqPZX_Q5pvdcOd02u6i_hr-Hn5UFCQ>
    <xmx:taHVYrUbZnhYcx4cIcIky9m0sdiYhtO2IYRKCLjYMZCB6zOg0UrlVw>
    <xmx:tqHVYvlFziuhYfTi7hOXLPF3VI-N4DfmOyZGPF7yMu1AlRjJKM86jQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 14:08:53 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Backport of 166d38632316 ("xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE")
Date:   Mon, 18 Jul 2022 14:08:16 -0400
Message-Id: <20220718180820.2555-1-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series backports upstream commit 166d3863231667c4f64dee72b77d1102cdfad11f
to all supported stable kernel trees.
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
