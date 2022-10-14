Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5D75FF27A
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 18:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJNQri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 12:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiJNQri (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 12:47:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49690160864;
        Fri, 14 Oct 2022 09:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=SpiMm+4/2Uf6t7YSi7YcJtcEEcCQolV28t2msYwh6JA=; t=1665766057; x=1666975657; 
        b=tOqBAKiBjk7m585biJ1wbAiTVBhDTN+EO2kMwRRuMY5PEtgCj50hlcanmd2NpsqWc5Kn+qVHmm7
        zbYwR0uQvRjniZ0IWHUEvG3gVd7j5odw496i/rfXHa5yV4pMadUfFloMp+igbNmyFQ/ZKNczUzYZE
        STs9IwZqNFfdUpDeMGjP8diQ/MtKXOAMDoCGBFtmSmZhWySNH/L+BTz3/ttPJxW/SU712HKBX7TSx
        7g8H2Iz3bCM2mj4otSzCL3SpCxjaBbnM6SpzkJq9bvbxWr/KLKta7AnuczObSb0X/E6Ac+cP5riR5
        Qjl/QQsat+UG57uC6W/R10Jx09GQz3woAPMg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ojNqQ-006gzN-1V;
        Fri, 14 Oct 2022 18:47:35 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcus Meissner <meissner@suse.de>,
        Jiri Kosina <jkosina@suse.de>,
        Steve deRosier <steve.derosier@gmail.com>
Subject: [RFC v5.4 0/3] mac80211 use-after-free fix
Date:   Fri, 14 Oct 2022 18:47:02 +0200
Message-Id: <20221014164705.31486-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

And the same for 5.4.

Again, not sure, maybe cherry-picking a bunch of changes is better.

johannes



