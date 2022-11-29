Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FE763C9F9
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 22:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbiK2VBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 16:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbiK2VBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 16:01:17 -0500
X-Greylist: delayed 86 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Nov 2022 13:01:15 PST
Received: from mail-40130.protonmail.ch (mail-40130.protonmail.ch [185.70.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002833121C
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 13:01:15 -0800 (PST)
Date:   Tue, 29 Nov 2022 21:01:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1669755674; x=1670014874;
        bh=Dsb2Q3t096TZCWZOwD9hJFaklciK3UAH3MUMlA0riKg=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=ATgAuHF9TKTSU+wJL3i5LQmBEGdNNJGY9mAVnevqJJDQR1bHgISMppo8kvUV0qR/l
         0hAgpfU0plLRbcq19nduHr4MF98G0HABoXg903sjHxbM3RuwNxhamiy2V2M0DLWi/M
         JfB7nZqf4kepsIw/nmJ+i9zEUCNwLEsPESO5bDel/hgjzNFkdHDkFCE+lWKBHsFXzJ
         OtYQWhpZRmOWB+xCX2OrQPpxSI9+T4/97L3P5BRGwkLcYW9VV/tuTsD+Ba0A7kuOc5
         vIqxMD6rbGMaBhBoIbSvlAwvqRgtaCu3YdKsIC/YV//9G3ZDAGzJwAhSRZIKV01nsn
         ldxtNehlQ4jrA==
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   hinxx <hinxx@protonmail.com>
Subject: help
Message-ID: <hocaGEwDO6MJc6ZekETyHaLlero9vGnO5qg-KsgSWCZEfl9AHOpV0HDN6PEP3MoNImsoA_l0eeWosYWarKJnRZOEykCc--28pw1D1wn7ltw=@protonmail.com>
Feedback-ID: 7622358:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

help


Sent with Proton Mail secure email.
