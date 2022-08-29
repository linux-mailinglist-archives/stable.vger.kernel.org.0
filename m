Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB225A583E
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 01:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiH2X5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 19:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiH2X5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 19:57:45 -0400
Received: from mail-oa1-x41.google.com (mail-oa1-x41.google.com [IPv6:2001:4860:4864:20::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8464459AC
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 16:57:44 -0700 (PDT)
Received: by mail-oa1-x41.google.com with SMTP id 586e51a60fabf-11f34610d4aso2279233fac.9
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 16:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=iu9zOIfcAiwsap/E8pMtyBJaF8QmCNfsoafx3EaWXyY=;
        b=iqlN5pT+fjRT+OWbDaBPIqZIBS4iI1PJBALgAXndugRk9s9mRpe0evpGRPmCDojOo5
         /gPTFJ1Q7IXo/y9+xg1ap1wJzadCkJjJh3dis2CaNHNVufem+r8zGhUJggRbXXSgBwNs
         mWDbfShS7VHd8eO96eWITNZfTv6ibChrCTV1tXLogIbUB90oebDMvzYWJTG9t0nUD1HS
         O+wCaXKqzRoYV84ksfEiL+RFAxi77TH7Hay75/9sGY9gK4edTHT5294jUgyo6x0eyQxk
         RoVs2Cov0zTdU0XZKVEiXPt7NERcLo+q/imQ0WdgXJskdnWsCxNX4EdoqOGvkwJR/7Pq
         AZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=iu9zOIfcAiwsap/E8pMtyBJaF8QmCNfsoafx3EaWXyY=;
        b=d5M0xsmAR9eKxdpSDyzCGbBzfOj995WY+f7m3h9iQkXeT9P/mU+EL2cgy7kgb4IG4n
         6U9zM2dG12hDj+RMH4ZHREz02G2ZF7aDbEZNlbXGnDzznucS+XE9r5pGeYAlhkq1P345
         r9rbmnuQc1IRHXax7opjt0Y1zrIQXWY/PKgDag99U5lGMI1rRwlNRjeBxQU9hIccDN0p
         uhQ6F6SkcnFk2A7jm4pL3T7aJLEu4hAp4EipdmrMv3iL6XLgiBphp5uh5s130PDpu9tB
         NsRf5879WQ14pdSZH4phLaleHwrWLbc5wPsF7wy/gwFxfbvY1jM9/j2tHbLQJuyd6/VO
         5SFQ==
X-Gm-Message-State: ACgBeo2Allc+qzOMKjtoyWkMgOL6ME8g4DVYFp2cXzz73Fss/NcFLRWF
        cfYTeZXKVb7t+77tvY8PxG0ar8Yk9UlwQoCMd9Q=
X-Google-Smtp-Source: AA6agR4GGx28gpCDpJTQavuy+5Bx0tn8/K9UrrEBW0UCGaA63A16NwbecEeHE6ZxdmPdrtqY5K6wbb2nOMzqzYXnks0=
X-Received: by 2002:a05:6808:1444:b0:344:f010:27d8 with SMTP id
 x4-20020a056808144400b00344f01027d8mr8210247oiv.33.1661817463896; Mon, 29 Aug
 2022 16:57:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:acd:0:0:0:0:0 with HTTP; Mon, 29 Aug 2022 16:57:43 -0700 (PDT)
Reply-To: fileconlot@gmail.com
From:   Gilbert <filelotcon@gmail.com>
Date:   Tue, 30 Aug 2022 00:57:43 +0100
Message-ID: <CAM-eAn=u5OLAKyosRkFKo3AxaikOKqMFy96VcjUcTtztX=jfWw@mail.gmail.com>
Subject: Letter of intent! and Please Read!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_50,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:41 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5105]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [filelotcon[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Sir/Ma,

Are you in need of a business or personal loan? Or is your business
struggling due to covid 19 pandemic, we are offering easy loans to
meet your needs, our funding and loans have repayment plans of 10 to
25 years' time for new and existing businesses, housing projects, and
individual financing.

We are willing to finance your request no matter where you are
stationed or located, our financing is global once you're willing to
meet the process and conditions. Your request will be processed and
sent to your account within 24 hours after the process is completed.

Kindly contact us in order for us to direct you to our procurement
officer, If you are interested.

Thank you in advance as we hope to meet your demand irrespective of
the volume in need.


Thanks & Regards
Mr. Gilbert.
