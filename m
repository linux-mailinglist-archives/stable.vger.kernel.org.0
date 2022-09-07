Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540EA5B0839
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 17:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiIGPNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 11:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiIGPNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 11:13:20 -0400
Received: from mailgw02.garantiserver.com (mailgw02.dnsflare.com [185.85.205.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E937AB5A60
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 08:13:18 -0700 (PDT)
Received: from 204139.dnsflare.com ([185.85.204.139]:46684)
        by mailgw02.garantiserver.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <opening@chevron.com>)
        id 1oVwgf-0007Hl-08
        for stable@vger.kernel.org;
        Wed, 07 Sep 2022 18:09:57 +0300
Received: from 204139.dnsflare.com (localhost [127.0.0.1])
        by 204139.dnsflare.com (Postfix) with ESMTP id C66A620E5E92
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 18:09:56 +0300 (+03)
X-SASI-Hits: BODYTEXTP_SIZE_3000_LESS 0.000000,
        BODYTEXTP_SIZE_400_LESS 0.000000, BODY_SIZE_1000_LESS 0.000000,
        BODY_SIZE_2000_LESS 0.000000, BODY_SIZE_200_299 0.000000,
        BODY_SIZE_5000_LESS 0.000000, BODY_SIZE_7000_LESS 0.000000,
        CTE_QUOTED_PRINTABLE 0.000000, DKIM_SIGNATURE 0.000000,
        FROM_NAME_PHRASE 0.000000, HTML_00_01 0.050000, HTML_00_10 0.050000,
        IN_REP_TO 0.000000, MULTIPLE_RCPTS 0.100000, NO_CTA_URI_FOUND 0.000000,
        NO_URI_HTTPS 0.000000, REFERENCES 0.000000, REPLYTO_FROM_DIFF_ADDY 0.100000,
        SMALL_BODY 0.000000, TO_UNDISCLOSED_RECIPIENTS 0.000000,
        WEBMAIL_SOURCE 0.000000, WEBMAIL_USER_AGENT 0.000000, __ANY_URI 0.000000,
        __AUTH_RES_DKIM_PASS 0.000000, __BODY_NO_MAILTO 0.000000, __CT 0.000000,
        __CTE 0.000000, __CT_TEXT_PLAIN 0.000000, __FRAUD_JOB 0.000000,
        __FROM_DOMAIN_NOT_IN_BODY 0.000000, __FROM_NAME_NOT_IN_BODY 0.000000,
        __FUR_HEADER 0.000000, __HAS_FROM 0.000000, __HAS_MSGID 0.000000,
        __HAS_REFERENCES 0.000000, __HAS_REPLYTO 0.000000,
        __HIGHBIT_ASCII_MIX 0.000000, __IN_REP_TO 0.000000,
        __MIME_TEXT_ONLY 0.000000, __MIME_TEXT_P 0.000000, __MIME_TEXT_P1 0.000000,
        __MIME_VERSION 0.000000, __MSGID_32HEX 0.000000, __NO_HTML_TAG_RAW 0.000000,
        __O365_FILTER_URI_ONLY 0.000000, __PHISH_SPEAR_STRUCTURE_1 0.000000,
        __PHISH_SPEAR_STRUCTURE_2 0.000000, __REFERENCES 0.000000,
        __SANE_MSGID 0.000000, __SUBJ_ALPHA_END 0.000000, __TO_MALFORMED_3 0.000000,
        __URI_MAILTO 0.000000, __URI_NO_WWW 0.000000, __URI_NS 0.000000,
        __USER_AGENT 0.000000, __USER_AGENT_ROUNDCUBE_WEBMAIL 0.000000
X-SASI-Probability: 8%
X-SASI-RCODE: 200
X-SASI-Version: Antispam-Engine: 4.1.4, AntispamData: 2022.9.7.143918
Authentication-Results: 204139.dnsflare.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=ornekdomain.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ornekdomain.com;
         h=content-transfer-encoding:user-agent:message-id:references
        :in-reply-to:reply-to:subject:subject:to:from:from:date:date
        :content-type:content-type:mime-version; s=dkim; t=1662563396;
         x=1665155397; bh=mCR9JnDguuueTX/tcXrmjUC0HG34iXdTZAlbbyv5Yqo=; b=
        JnucBg8jY2gRwiCgZvNTUe2wcbpo0WUk/rpmfCnqjqdIVhruiEC/lL4RN61ulFAN
        XhSJMl7+hKkK2FqlHWMv/HzGIHLhVaGC7W7aIlZ01pEYp++ns/FMaVD4AQNiKavN
        8psogf3MMlz/GDH11XFr9dcJ9Hcrwh8cxQ8teeGhnEM=
X-Virus-Scanned: Debian amavisd-new at dione.dnsflare.com
X-Spam-Score: 3.996
X-Spam-Level: ****
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_40,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_REPLYTO,KHOP_HELO_FCRDNS,ODD_FREEM_REPTO,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
Received: from 204139.dnsflare.com ([127.0.0.1])
        by 204139.dnsflare.com (204139.dnsflare.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LKalxBrq_zkF for <stable@vger.kernel.org>;
        Wed,  7 Sep 2022 18:09:56 +0300 (+03)
Received: from _ (localhost [127.0.0.1])
        by 204139.dnsflare.com (Postfix) with ESMTPSA id DDF6620E5E94;
        Wed,  7 Sep 2022 17:57:58 +0300 (+03)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date:   Wed, 07 Sep 2022 15:57:58 +0100
From:   Chevron Energy Corporation <opening@chevron.com>
To:     undisclosed-recipients:;
Subject: Job Opportunity at Chevron
Reply-To: chevron.uk@europe.com
Mail-Reply-To: chevron.uk@europe.com
In-Reply-To: <1d34d275eff93e4e7cec68b60872fdcc@chevron.com>
References: <1d34d275eff93e4e7cec68b60872fdcc@chevron.com>
Message-ID: <a27fc3b33b05e6a1eaa5738967e6f134@chevron.com>
X-Sender: opening@chevron.com
User-Agent: Roundcube Webmail
Content-Transfer-Encoding: quoted-printable
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chevron Corporation is currently recruiting foreign applicants on=20
various job positions available kindly apply by sending your CV/r=C3=A9su=
m=C3=A9=20
to chevron.uk@europe.com for more details.

HR Management
