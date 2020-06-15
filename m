Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE30A1F8ED8
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 08:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgFOG5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 02:57:18 -0400
Received: from sonic311-17.consmr.mail.bf2.yahoo.com ([74.6.131.240]:40125
        "EHLO sonic311-17.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728283AbgFOG5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 02:57:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1592204237; bh=19dvBZ7onruyA9Kb+oMmS5rb2QWnDzjDcGlSAu5K3IA=; h=Date:From:Reply-To:Subject:References:From:Subject; b=WoFnbNc5dFUMUqr5s+GcNtjUsQMPhehvMeX31D8an9DESE9bMVRBZrv34KjuxXtCnOEMJQvDveBe55N3VcYj30AVNIUdregYj3r7kI5d5PBijkrUapfepSyguHLjkZx6Poqm/g11FdeGcb2XO7EsYviuYGNKfHcGvgGzxgGfvP1ZZMKLpQA+tobUSUA66IijI5OmIyj5yEXL88Aa50AAQqFgkPLwPZ3clbyxYyUpMsKIBdlEGVcZXr7aiLiC+AcDW/Jn+pFVcWBoCr0cGO/3CerrunDSEapLMp9GWBYocUT0fJUMoJt154kvnSoMha7Dzc5YL0Tepwq1i+EBfHV3Ug==
X-YMail-OSG: _kt.h9cVM1k1PRms3zi2xIMWqmS.ZG01yOM_ieBCoiV0HgLgmmX5WKduEERvhUp
 2m7t0zcrMbeF2C_XDzuVOvdkgtVoktQhxCrRIU1sed_TB3ljZlZPzGWSubEhxtWl.PbWKnB4_kxz
 _KMoM4F5dUc4pKWXCbXDZsY24M5d2AlPWElJS4Y5HoK3aBhPoSSr_..s6zjpTngSAKPZYQErevE8
 YnoQlwK77wtdm_AbgZldHnu7m6E7NYYY4nhAnF0SCJHQ1NzbNnFqhADznl6F0PxAHhjucg7SPauq
 KvH9Jqs9Du2WMauluAPtSMMTrR9MRo1qRZGGrWQIoacNEU1tb9wRPq.aJE5VOxo_a3_kPbO0MUG.
 yCvAdVc5nB6Mq4bTTq8_AQ2V19ug.wTnc29ttrN2eFhCvHrux5Gl6wqTgmgrbKir6QJd_HmdtF6A
 XukbqVhtG7nfbTNwQHygA58cJ7ju7rBgq0Uy1iYZQkyAxmciQOaz6KvJFj2v0f05_uXfiMhXV5lP
 ywjHSVTBN0zWa5WOotrfT4TeQ0Si4.yZiJvEBSqwWP2xLxR5de5.OeYjX4Qxc7qKk5VhQrPkRVmx
 YKQXY0jA1iuxFwT2_VCiupzNQ7ddpKsURKfSr4d.07r9sm.ZWkVcCwAswX09ldpJ4kZMQ2IwJJyz
 yCx5tPyhN_ufYvPGjIGY_P1tehkBiZj8oX9A1YiVbZzjYKUnowfdF5KkPVfwzg0TEI1OxszRJ6eN
 XJmBxgZf8ficZF0xb_5RVRBedDncUpyfxdjmXi83xV2KBs0SB5QwB23KjjUezKEBFfOwnJSNJVdF
 ZlkWNJDoyjQiw40P7tfW8iAmE16cido15GczVx6Bet3PXKqVYGRc00YiZ9PW4IbrNnuJzQnRRjdv
 AIWWYUBqIKLB8tOFumwkG4hdJrpTGw4qtd77Yn_YtAiKYEm.A6zDXShIiUstxHRosquoRGJDGhcX
 i2.QP_D_lBsV2PhCNdSfWWnAUixSAN_8ig_pu0gSr28OKEX3ZyE3jk4NePuLVbMxHamVBcWM.i_4
 9vrDe7Ob0SY8di1QzzRsn6yoG9P8ToLBt9qE6IoYvho6kdxQx5K7EfZTifSWKWk6GxeKb6iydhn2
 OiJtkhnWJkJkHj5N5adH9sUp72xE3rnMv8UPQ2JvzNus7d00XeC7b2aH7I9PZx4zOwvmG5.KCKoS
 JUOwG.I8DwCjdm6Hajeph0RDIkH_BWR6T4SxFe3KsVjsurnS8kOfOrQuDe02xKvafpc.4joXhsAv
 tx0CPtX5CDP4T4ZsojwMutPXmKmC3uY5huZr7DA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.bf2.yahoo.com with HTTP; Mon, 15 Jun 2020 06:57:17 +0000
Date:   Mon, 15 Jun 2020 06:55:16 +0000 (UTC)
From:   Brown <zxa16@gtabop.in>
Reply-To: brownhilton02@gmail.com
Message-ID: <1255514480.600639.1592204116104@mail.yahoo.com>
Subject: GOOD DAY TO YOU,KINDLY CHECK THE MAIL I SNT TO YOU.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1255514480.600639.1592204116104.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16119 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Good day to you, kindly confirm to me if you did receive the mail I sent to you yesterday.
Regards,
Brown.
