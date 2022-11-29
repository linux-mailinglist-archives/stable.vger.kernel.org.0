Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1E563C73D
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 19:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbiK2Sej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 13:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiK2Sei (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 13:34:38 -0500
X-Greylist: delayed 380 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Nov 2022 10:34:37 PST
Received: from mail1.systemli.org (mail1.systemli.org [93.190.126.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382455A6DE
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 10:34:36 -0800 (PST)
Message-ID: <65796fc0-76ed-7a77-5258-0df2995d67c5@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1669746495;
        bh=EsYbKkXrTxzgiye5DZC8naoB/9S3HRSBVT7Jf8GpOIY=;
        h=Date:To:Cc:From:Subject:From;
        b=fo3D2HJzuhLc3twnN1TXbDMw2xYCSYns75LeNddk2zNaN0eHyh2u3YsRXezhf4XvU
         EXDQ5Tsrw4Jc8teODse63w0eKt8QK7g6McP/Pid3JZu7JH0w+pMxFMK7eaCn7HYQvm
         CDahRZSneLjwAtVxeh6JqH0c+OXw9UOWX0/SsIthmbCU2xcGPiZbx0Ga1X1hQkZwnC
         5ynxanbxvfzob8B/cmT/fU1BCa4wKPkGKkobtfFqqqA+3ZAT2FAesJxvhHbGLM/4KA
         UJ7ISzxIkjnLYh6157j4xp/q3pxeykVSdMsclYQHxkv6Ou2bVIqu+hypNA5u1HXnsh
         x66CvJfURdE3g==
Date:   Tue, 29 Nov 2022 19:28:13 +0100
MIME-Version: 1.0
To:     stable@vger.kernel.org
Content-Language: en-US
Cc:     taozhang <taozhang@bestechnic.com>
From:   Nick <vincent@systemli.org>
Subject: backport "wifi: mac80211: fix memory free error when registering
 wiphy fail"
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I think the patch 50b2e8711462409cd368c41067405aa446dfa2af ("wifi: 
mac80211: fix memory free error when registering wiphy fail") should be 
backported to 5.15 as its fixing memory handling. Already run-tested 
with OpenWrt on 5.15 kernel.

Bests
Nick

