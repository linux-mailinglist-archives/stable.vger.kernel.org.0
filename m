Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF66E65BB2F
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 08:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbjACHZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 02:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236806AbjACHZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 02:25:44 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9710B49E
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 23:25:39 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-14455716674so35939432fac.7
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 23:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0nNMMGww+HESuJGrtt7OTDK73JOC6okX5AlTUFO5dvk=;
        b=FtG8AZqUStGiK435qQBb7ytOLII+YMPdVaAkYc/9/Uzr0TZwLIKY/0OYEBqvyIdmDY
         9DUfb0Zn6ECxYb9hWEXBCN1Vgu5wQq+k+nFgTIKAAUSK5hwfmd+sMiZKJpCkloyQIyDU
         u78pfQTTwOt587HS7sJmbPpSvVliocvOUBCFJx2PfrblOaUqB4JicJM7SiVXjuj6Lrvs
         s3+obgVWNK1et7exmCKO3ltbaiFo7G8BbFKULDFsHICDUT0MmcqDGrJsJtsNyrSR2CsK
         Wpx9Gb6rN9dBlsuDSmdUV1/UsYYl0nBy3lqOY1pW6qXiacxHcapg66QMNhvUA3b8iwUo
         rIFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0nNMMGww+HESuJGrtt7OTDK73JOC6okX5AlTUFO5dvk=;
        b=4MibLJGq5R4D9GFdP1dJgiYXslymSIWONKw1NuHlFzXyEqqg6SbE3YBSvLcE1VD5X8
         nc+Oy6z2WrHzdOVvZEAi8jC4fRCNz7eeUrUZioGrWw7E5L0JpDwrXboHxAOVXRlHANS+
         sVKe/QuD0QqTXKRLY6rNPdtxcBorT6rc6pt3OjbM9xmCqp2eclD1bxsLBPqz8Y37oQct
         wPoRIVg1gx2FuJ8gG7yG8U9rN4q4rTLvb02kGYVKlIt6A8yQrWZHcYmRCjP0HSkPcOg6
         9ULRQ8Z50gXHz/dX+Opu8zzBiGlj9gW8PoAT6I+QlHYIBa9MW658CkNNY3QyyvbAVkSs
         7fyA==
X-Gm-Message-State: AFqh2krVleXSK3IRkN7A+sKf65OCGcr2ufzFeN/qx++LkyK7xwm+tPmb
        DhT+Dzslqk4PiEHRfcAo04XGuz5OibeKBOkK8nQ=
X-Google-Smtp-Source: AMrXdXsy8TEbxowp/DYsB8PHvIyW1la1xn7HJzwbXABsFcGyFBRPjgpk3fBQcG/ygYhh/V8oUbre15YdjVFFtPbg15w=
X-Received: by 2002:a05:6870:7f0e:b0:150:39c6:15ba with SMTP id
 xa14-20020a0568707f0e00b0015039c615bamr1383164oab.209.1672730739237; Mon, 02
 Jan 2023 23:25:39 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6358:5e17:b0:e7:8a4b:fe30 with HTTP; Mon, 2 Jan 2023
 23:25:38 -0800 (PST)
Reply-To: kreditlinel25@gmail.com
From:   INFO <shivdvlbind62986@gmail.com>
Date:   Mon, 2 Jan 2023 23:25:38 -0800
Message-ID: <CABQZbM9vdkTo_oubh_nmTMDmtecqi450vNhZ=m5Rd=XfvngmZA@mail.gmail.com>
Subject: lening
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:32 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 HK_RANDOM_ENVFROM Envelope sender username looks random
        *  1.0 HK_RANDOM_FROM From username looks random
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [kreditlinel25[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [shivdvlbind62986[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [shivdvlbind62986[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Goede dag,

   Wij zijn gespecialiseerd in het verstrekken van leningen voor
bedrijven, projecten, zakelijke en persoonlijke leningen tegen een
rentepercentage van 2% per jaar.

Wij bieden: -
* Investeringen in projectleningen
* Investeringen in zakelijke leningen
* Persoonlijke Lening Investeringen

Neem contact met ons op voor meer details.

Ondergetekende,
Online reclamebureau.
