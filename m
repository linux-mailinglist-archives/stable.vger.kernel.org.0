Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4709256279D
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 02:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiGAAKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 20:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiGAAKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 20:10:22 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6144D4D4
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 17:10:17 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 69BD05C00A3;
        Thu, 30 Jun 2022 20:10:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Jun 2022 20:10:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:message-id:mime-version:reply-to
        :sender:subject:subject:to:to; s=fm2; t=1656634214; x=
        1656720614; bh=fRJBB2CnMIUg5NV6nJ1IufinDZDpHUNh3Z3kruSktl4=; b=G
        SQUgBB/OofT0S7UUpxWUxZTSC9Y1LQBQIjBq/gm4fp0nw5xHNDQreTg9VowkMAxt
        EhEKitapukHcXfzENJLEFZ9NsPlsW/IoHEu+/qskPkOU7C8L3bMDHT0Rd3Wae2Dr
        RbL5Y9I7i0AyZ62aBC7DURbzF0an8WR4yyjfIG14qPRDBRqQd7S/FlpBziqjCYYp
        nTkT0EdssNY65h6w5LtV1CdfHpv+bYgUaRvpkEaGPhrGjaj4x/zE7WEX1xm62ID1
        rlOuV1V8FxOpFwsamvYPjLqbS5rA9twX3ydYfw6shQGHLvZkQyf2XFhSwbpMekOq
        17vmlUyt88STvsd/MQXMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1656634214; x=1656720614; bh=fRJBB2CnMIUg5NV6nJ1IufinDZDpHUNh3Z3
        kruSktl4=; b=jHcx3cb+99Pmwul9hx4GDn0f3r/luzIRSDzAfyPV4gFBbaL3qAy
        CNyPqGXZJ399fxvhdtsEBwQeTe5nc8rhBRDkZeOQnvvesBLMirp6uXjZ5w0dXltT
        fVx7NnMU9fhINvDJcujo6yPDLiLXw7dD3Zj+WBRW+ImrpezSH2Fa3C6RToUUY729
        BjGSu5hhLAZ+SA+x+GbXjagGs+cdcDrZ9c1JkEhTCBL4e/2lJFOUSh0SydSQV0fk
        s0w+gNAsOKplUrqpxUKfXOFbDAUMQqeDwyBK9EyEHDRapkfImIdkInmSPi2eEPl+
        AMhV0avXyy+FrEdCATj7waDhlVkvFKL2Pqg==
X-ME-Sender: <xms:ZTu-YuenWs1cWiUDJT9YOW-0eWPgzZJBnY2RvIPW1i-lsqx6CzLfyA>
    <xme:ZTu-YoMjXUVcHCxfsZY9ETzGyT3L5fM1_lKVvDV-uLCOTxFrXw_nwr2RXdJjS_hQD
    6_uBBy4Drvi9zY>
X-ME-Received: <xmr:ZTu-YvgotITkAyk5VZdTfGRYZhIB_H6VOu2_a_ewHA2KMqexHOPw7ooLHxQMvQ0xPAa7mEmzcO7h>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehvddgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepffgvmhhiucfo
    rghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhnghhslh
    grsgdrtghomheqnecuggftrfgrthhtvghrnhepvdefgeekvdekgfffgeekhfeijedtffek
    hefhleehfeejueetgfelgefgtdevieelnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgr
    sgdrtghomh
X-ME-Proxy: <xmx:ZTu-Yr-tB3c2ToscFx9sP6_rF2r1hX9yWhlhqjzpzCYvd7SYf8nm0w>
    <xmx:ZTu-YqtYtp5VN_uJQ6WW75RcUuRmnCa3PDKcRrXQKGBHLtRYWTH7nA>
    <xmx:ZTu-YiH_1-8yRwJeIV5nxFKM44G0o-w8VpPZN6xE-rOPrzEpgON8Eg>
    <xmx:Zju-YvUR2fU-m_bm7CdvK3kfVRZ8bMUtOB3D781hpfmDnoAZWSwpQg>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Jun 2022 20:10:13 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Xen developer discussion <xen-devel@lists.xenproject.org>
Subject: Hopefully correct backports for gntdev deadlock
Date:   Thu, 30 Jun 2022 20:09:47 -0400
Message-Id: <20220701000951.5072-1-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This backports "xen/gntdev: Avoid blocking in unmap_grant_pages()" to
the various stable trees, hopefully correctly.

