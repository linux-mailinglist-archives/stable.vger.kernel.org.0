Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5BE65A5DB
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 17:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiLaQ7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 11:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbiLaQ7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 11:59:03 -0500
Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A932B1C1
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 08:59:01 -0800 (PST)
Date:   Sat, 31 Dec 2022 16:58:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.kalamlacki.eu;
        s=protonmail2; t=1672505939; x=1672765139;
        bh=SH5+E6TKxV12WWRERbcY8xdsw207XQD0vA43FbA8zBE=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=7opvwvIQwnFp3CRDOLLi9nfVkYR6mojUUfTbYAORe2W+ertU3+FYMOplPM/qSQfWo
         fwKduvNae9jH8eAXoKpcWe1h/qJaneB7b0QmKvAkka1MKQOpNmmcbbusWDHICdGua9
         BhrPvPPldkLOihgdo6/4oclbT40Q98kaT1Q3ea3h8o0ImaN8N4BvND0lfxtNnm1i2A
         1e9Kf6jcNKCfQlQLxPOEvPl7IIgYETX/xyZC3RUdLHKsKMVBYlDsiY+iKTXpTcrlKZ
         DJB1/gwjLdxw8qxl6ZfmksqpcPB/UGVLi3mq5iOcIVhvIyfKiQf6uvNkwOnwXo9CMc
         OoVE8vRzYFkfg==
To:     stable@vger.kernel.org
From:   =?utf-8?Q?=C5=81ukasz_Kalam=C5=82acki?= <lukasz@pm.kalamlacki.eu>
Subject: Cannot compile 6.1.2 kernel release
Message-ID: <b0ef1e48-ca8d-9a5e-6e21-688711dab650@pm.kalamlacki.eu>
Feedback-ID: 42407704:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey,


Do you have an issue compiling 6.1.2 linux kernel?

I cannot compile it.


Best,

=C5=81ukasz


