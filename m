Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5AE6BF085
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 19:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjCQSQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 14:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjCQSQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 14:16:23 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17871C3CED
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 11:16:23 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id w9so23775931edc.3
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 11:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679076981;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZiHUNwfK0nkdptqpaTQtGRZZAMr/vFU76jx2DJe0dqY=;
        b=WjCQjbzMHT+yh4fQQihC8OPbkLPVT5dZU6Db7bigjDzxxRVMJ2GruF5OQQPlfkPPJh
         ALkfNHxCTZKwsIeNi4ey5WsX221WWlSfp388ttLA/tO6rtNpynT0uENILQrO7ZdzGEWL
         Q4ERqozDPjTBMuI3Viz89iKVH54zEtAVzMCrTjTES8YZciznKg64bA6hPWvnFjYkZhBK
         WiRte9LbE9kUW09JJ0AbHPgXIo1wlbLm+LDeQJEg09ZNoSXPpPUQKHc7W1iqctzxMOdm
         kC47sDlZVqYNmTVItqgxW5vdczArAliyD//SzvV2WmyDMj/ragFqZjPuLTc53he7r7Yc
         a6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679076981;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZiHUNwfK0nkdptqpaTQtGRZZAMr/vFU76jx2DJe0dqY=;
        b=x1A2kxRDBs4ZE8v/cvDRzNtcnrysIXq5+3tHhv5mnIXfNvRZh1ZcFGaEoQV5OFdAEA
         HbWVclhvZhj/DAH6/jD0arz+v63LcV8IqSwWyPg3UY/40yEyDu8feaJs/PSlr5J5ojcg
         JOxkPG7D1uZ4Gt1Ndy7WF/VL5NyKMuvZvu9N/1PkTt4HO0zKvZ2gondb9S1iHYZ4cD7v
         0oX28Bs4k6DAOf784J2NWLOc7HPhnGZoBIIF4TP4UtCJYZArWqX+aNT6csrSyeXMHVUL
         0UT0yBWl6to2dk/RBnYXHiRA/jzguQ+WNwMWRpSAyyD2bwCwaodFYe1fPxYNIWf33u3F
         P40g==
X-Gm-Message-State: AO0yUKXDmoxoIwPSYdogHdAUF8imYVOXMVH3Ymr+baIfHFu1/cOHdPab
        0V94UV+/TVEGE7OcCeOIrRAZriXq3WN24fLN/YM=
X-Google-Smtp-Source: AK7set8CXrBWST8Zr7mXWpZHRh9RKF2rIv+fe/R88M/pR9mwxL8Wghr7lCJ8xvti3ylzXpcacJe+a6PxWAgtxhAukI0=
X-Received: by 2002:a50:8e02:0:b0:4fa:ff23:a87a with SMTP id
 2-20020a508e02000000b004faff23a87amr2231553edw.5.1679076981542; Fri, 17 Mar
 2023 11:16:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6f02:c3a1:b0:4a:17f2:cc9c with HTTP; Fri, 17 Mar 2023
 11:16:20 -0700 (PDT)
From:   Stephen Jack <jstpehen655@gmail.com>
Date:   Fri, 17 Mar 2023 23:46:20 +0530
Message-ID: <CACbRhM-b544Hi7RzL2zShsDWganm_YBc06aBUX92eaXTnmpkbA@mail.gmail.com>
Subject: Business proposal
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.7 required=5.0 tests=ADVANCE_FEE_4_NEW,BAYES_99,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52d listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 0.9935]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [jstpehen655[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jstpehen655[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.2 ADVANCE_FEE_4_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
-- 
Sorry for intruding into your privacy
I am Mr.Stephen Jack ,
Compliment of the season.

I got your contact email from the international business directorate
and I decided to let you know about the lucrative business
opportunity of supplying a raw material to the company
where I work as a staff,
I am an employee to a multi international company.

we use a certain raw material in our pharmaceutical firm
for the manufacture of animal vaccines and many more.

My intention is to give you the contact information of the
local manufacturer of this raw material in India and every
detail regarding how to supply the material to my company
if you're interested, my company can pay in advance for this
material.

Due to some reasons, which I will explain in my next email,
I cannot procure this material and supply it to my company
myself due to the fact that I am a staff in the company.

Please get back to me as soon as possible
for further detail if you are interested.

Thanks, and regards
Stephen.
