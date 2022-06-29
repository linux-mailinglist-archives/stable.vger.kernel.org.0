Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9EF56164A
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 11:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbiF3J1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 05:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiF3J1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 05:27:24 -0400
X-Greylist: delayed 64430 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Jun 2022 02:27:23 PDT
Received: from mailgw02.garantiserver.com (mailgw02.dnsflare.com [185.85.205.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BC63A71C
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 02:27:23 -0700 (PDT)
Received: from 204139.dnsflare.com ([185.85.204.139]:46252)
        by mailgw02.garantiserver.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <greyson.edwardchevron@gmail.com>)
        id 1o6Zh3-0003AL-19
        for stable@vger.kernel.org;
        Wed, 29 Jun 2022 18:33:29 +0300
Received: from 204139.dnsflare.com (localhost [127.0.0.1])
        by 204139.dnsflare.com (Postfix) with ESMTP id 3C41620E60D7
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 18:33:29 +0300 (+03)
X-SASI-Hits: BODYTEXTP_SIZE_3000_LESS 0.000000,
        BODYTEXTP_SIZE_400_LESS 0.000000, BODY_SIZE_1000_LESS 0.000000,
        BODY_SIZE_2000_LESS 0.000000, BODY_SIZE_300_399 0.000000,
        BODY_SIZE_5000_LESS 0.000000, BODY_SIZE_7000_LESS 0.000000,
        CTE_QUOTED_PRINTABLE 0.000000, DKIM_SIGNATURE 0.000000,
        FORGED_FROM_GMAIL 0.100000, FRAUD_X3 1.000000, FROM_NAME_PHRASE 0.000000,
        HTML_00_01 0.050000, HTML_00_10 0.050000, IN_REP_TO 0.000000,
        LEGITIMATE_SIGNS 0.000000, MSG_THREAD 0.000000, MULTIPLE_RCPTS 0.100000,
        NO_CTA_URI_FOUND 0.000000, NO_URI_HTTPS 0.000000, REFERENCES 0.000000,
        REPLYTO_FROM_DIFF_ADDY 0.100000, TO_UNDISCLOSED_RECIPIENTS 0.000000,
        TRANSACTIONAL 0.000000, WEBMAIL_SOURCE 0.000000, WEBMAIL_USER_AGENT 0.000000,
        __ANY_URI 0.000000, __AUTH_RES_DKIM_PASS 0.000000, __BODY_NO_MAILTO 0.000000,
        __BOUNCE_CHALLENGE_SUBJ 0.000000, __BOUNCE_NDR_SUBJ_EXEMPT 0.000000,
        __CT 0.000000, __CTE 0.000000, __CT_TEXT_PLAIN 0.000000,
        __DC_PHRASE 0.000000, __DQ_NEG_DOMAIN 0.000000, __DQ_NEG_HEUR 0.000000,
        __DQ_NEG_IP 0.000000, __FRAUD_INTRO 0.000000, __FRAUD_PARTNERSHIP 0.000000,
        __FRAUD_SUBJ_A 0.000000, __FRAUD_WEBMAIL 0.000000,
        __FRAUD_WEBMAIL_FROM 0.000000, __FROM_DOMAIN_NOT_IN_BODY 0.000000,
        __FROM_GMAIL 0.000000, __FROM_NAME_NOT_IN_BODY 0.000000,
        __FUR_HEADER 0.000000, __HAS_FROM 0.000000, __HAS_MSGID 0.000000,
        __HAS_REFERENCES 0.000000, __HAS_REPLYTO 0.000000, __INT_PROD_LOC 0.000000,
        __IN_REP_TO 0.000000, __MIME_TEXT_ONLY 0.000000, __MIME_TEXT_P 0.000000,
        __MIME_TEXT_P1 0.000000, __MIME_VERSION 0.000000, __MSGID_32HEX 0.000000,
        __NO_HTML_TAG_RAW 0.000000, __PHISH_SPEAR_GREETING 0.000000,
        __PHISH_SPEAR_STRUCTURE_1 0.000000, __PHISH_SPEAR_STRUCTURE_2 0.000000,
        __PHISH_SPEAR_SUBJ_ALERT 0.000000, __REFERENCES 0.000000,
        __SANE_MSGID 0.000000, __SUBJ_ALPHA_NEGATE 0.000000, __SUBJ_REPLY 0.000000,
        __SUBJ_TRANSACTIONAL 0.000000, __SUBJ_TR_GEN 0.000000,
        __TO_MALFORMED_3 0.000000, __URI_MAILTO 0.000000, __URI_NO_WWW 0.000000,
        __URI_NS 0.000000, __USER_AGENT 0.000000,
        __USER_AGENT_ROUNDCUBE_WEBMAIL 0.000000
X-SASI-Probability: 14%
X-SASI-RCODE: 200
X-SASI-Version: Antispam-Engine: 4.1.4, AntispamData: 2022.6.29.145118
Authentication-Results: 204139.dnsflare.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=ornekdomain.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ornekdomain.com;
         h=content-transfer-encoding:user-agent:message-id:references
        :in-reply-to:reply-to:subject:subject:to:from:from:date:date
        :content-type:content-type:mime-version; s=dkim; t=1656516808;
         x=1659108809; bh=lsDT4tvAc3Bj211wDsf28O2PMftqo7mPcbgISGd07Jw=; b=
        eIzo0M574Vs/47ChaY2N7dDyETiHVWP4b4OX7vS/jy2dSsYcoAnxccur2uiVDYyf
        aISeX3OXQ5X/cqm62K1nryKf1oJNQx5qATazXCbCYPH+NlhYOSN47jIO47iq/Ql6
        gicdFnV4ooSjZk6pnxWtY3yS4JfdFi0ll+1KDLQOGxo=
X-Virus-Scanned: Debian amavisd-new at dione.dnsflare.com
Received: from 204139.dnsflare.com ([127.0.0.1])
        by 204139.dnsflare.com (204139.dnsflare.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3Ggr3Br3t45B for <stable@vger.kernel.org>;
        Wed, 29 Jun 2022 18:33:28 +0300 (+03)
Received: from _ (localhost [127.0.0.1])
        by 204139.dnsflare.com (Postfix) with ESMTPSA id B06C020E60FD;
        Wed, 29 Jun 2022 16:52:04 +0300 (+03)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date:   Wed, 29 Jun 2022 14:52:04 +0100
From:   "Chevron HR, Employment" <greyson.edwardchevron@gmail.com>
To:     undisclosed-recipients:;
Subject: Re: Job vacancy notification
Reply-To: greyson@chevron-hr.com
Mail-Reply-To: greyson@chevron-hr.com
In-Reply-To: <b7ba69e8174dfc469ccc7d7ad7a46a5c@gmail.com>
References: <e5091f490ebe479157511bd842971fc0@outlook.com>
 <b7ba69e8174dfc469ccc7d7ad7a46a5c@gmail.com>
Message-ID: <9eb03f9b53d6796ec70f5e6e9a62fcb7@gmail.com>
X-Sender: greyson.edwardchevron@gmail.com
User-Agent: Roundcube Webmail
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.6 required=5.0 tests=BAYES_50,DKIM_ADSP_CUSTOM_MED,
        DKIM_INVALID,DKIM_SIGNED,FORGED_GMAIL_RCVD,FREEMAIL_FROM,
        KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ATTN,

      This is to inform you that we are currently hiring foreign=20
international reputable and experienced applicants on various job=20
positions available if you are interested kindly apply by sending your=20
CV/r=C3=A9sum=C3=A9 to greyson@chevron-hr.com for more details.

Regards
Greyson Edwards
EMEA Recruitment Team Lead.
HR Chevron Corporation London UK
