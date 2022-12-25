Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C73655DEE
	for <lists+stable@lfdr.de>; Sun, 25 Dec 2022 18:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiLYRBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Dec 2022 12:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiLYRBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Dec 2022 12:01:12 -0500
Received: from ya.lv (ya.lv [138.201.201.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722322675
        for <stable@vger.kernel.org>; Sun, 25 Dec 2022 09:01:08 -0800 (PST)
Received: by ya.lv (Postfix, from userid 5002)
        id 66ABD9223B2; Sun, 25 Dec 2022 19:01:06 +0200 (EET)
DKIM-Filter: OpenDKIM Filter v2.11.0 ya.lv 66ABD9223B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.lv; s=default;
        t=1671987666; bh=3kWjvzxx/2V7JVPKm2zH3k8yX9Nwi/kqCffjwEpr1bA=;
        h=Date:From:Subject:From;
        b=qiX7/paKO5XVp7pvXfgj5FbHXjrBjhNcBTeF+zgOTe7oMtSVHVl9Jwv1X0MO9wsQv
         9Rle1hgSgDlh4UbH/46U2/5LH5tlC7qZTwHepyRAYUN4pwjbCnebX+PqAOYMS9k1iu
         K1+LaZhHl3zjZY20D4LVDiPDgtD9+8fu0AuiLjFc=
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_20,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        SPF_HELO_PASS,SPF_PASS,TVD_SPACE_RATIO autolearn=no autolearn_force=no
        version=3.4.6
Received: from dummy.faircode.eu (89-39-107-194.hosted-by-worldstream.net [89.39.107.194])
        by ya.lv (Postfix) with ESMTPSA id 737C19223AF;
        Sun, 25 Dec 2022 19:01:02 +0200 (EET)
DKIM-Filter: OpenDKIM Filter v2.11.0 ya.lv 737C19223AF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.lv; s=default;
        t=1671987665; bh=3kWjvzxx/2V7JVPKm2zH3k8yX9Nwi/kqCffjwEpr1bA=;
        h=Date:From:Subject:From;
        b=PV/SYrGJFAzJjXPsLOkf7CrylWjaBkHnatqj+Vj6WyOX2eZG2BMV0IV+ir2zXDDbs
         S301t4qQeOStvdAvo1IejpAwSAa0KHf5wm55Zd61f0fiQICGwtHPOZz5d6LqRjL/of
         HWQL7fnkWvJioX1r6rGO/HveJcF+Li+1sRRYYWno=
Date:   Sun, 25 Dec 2022 12:34:47 +0000 (UTC)
From:   TRANSPARENCY <TRANSPARENCY@YA.LV>
Message-ID: <29d4b183-be26-423c-a4b8-fcdc61ef0b1b@YA.LV>
Subject: Unsafe
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <29d4b183-be26-423c-a4b8-fcdc61ef0b1b@YA.LV>
X-Spam-Level: **
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

https://privatebin.net/?2d90fc7c19becd01#HbAn49oMWfNPhGJThUudjDvjPU4whi2gaBFmD9ifPZhR
