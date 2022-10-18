Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6FA60309C
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 18:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiJRQR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 12:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJRQR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 12:17:59 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B71B7F78
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 09:17:58 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id bh7-20020a05600c3d0700b003c6fb3b2052so3450452wmb.2
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 09:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IrqztLZdzglCf/38sXjFn2ylMHES9scoFt0eK8rUS8s=;
        b=OpqmHLJdL7PsLnGCKPWzSpG2E1L7HE6aK/Ket55jx5N+kyHoGiDDmMnpZ7r4qyPbH0
         dmn38o2s8MFjcx82dLNCCHWc+uTy86pDSkk3dR7/7CPi537PsmrprI57KRNQKCq/oqda
         XEPdKMfZeVR5eEq5V+feXey+sgy6344yaFSALRk16P2L1d982cmbKyIc25jTn/QrzQEV
         b/72AwodIDA9uisOgo0qezpsRnfN09VehHRSZsfOg8CerOE9CFLbGfet2H6pUcm0WCSN
         HlKArbDin0vpg4XXUT3pRgq67xQRVYl11a4KSYo4UcYz20DCKB3Lx4we34lrEPRvmNPm
         CiDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IrqztLZdzglCf/38sXjFn2ylMHES9scoFt0eK8rUS8s=;
        b=bugWaFTbJEFzUVR8KksKKApDYeA/dli3DHgmfmFnK+DD16N+yxXvqUbQEacf5MYgEI
         Hq36HNjCEHPkw774G5s822uxd8a6H+Rg1jKpDJwLO2FdveNdY+MCx4uQXvZ9vJhHmu1s
         Oguo9A0VCknUKRvEKFDYXzdm5t58R6J0NeuIL8ilo6r8lrLMAQFbewYp75gsRByAYaoD
         1NHscvwEObb47rEvHziUMDViSZvJobizyP9ZhZXtkSiPAv61SOHWgiqVorFw0VKMK6xz
         joc96G8hOW6F3ZiFiaamy1e5RS4bD8/7mgFA0shgoiDNITa3Q63GLsESSSi3iRNnHs9E
         Qh/g==
X-Gm-Message-State: ACrzQf1bJgvqkfICtrO/oELcE8luhqDkG+w9nkZJi0CNEzwuT939U6my
        jZySVKZm2qh2COlp7GIEk4iqb1VM6BWvx/6G8GI=
X-Google-Smtp-Source: AMsMyM7gIpiOl3Mav+rDehndzA4lirZGV41tKmVB159Luz/p6l0wFcjre+XZoM6UwqHT8I6cdlNqdeiKzN5drjl6OFw=
X-Received: by 2002:a05:600c:1906:b0:3c6:f83e:d15f with SMTP id
 j6-20020a05600c190600b003c6f83ed15fmr7277844wmq.205.1666109876622; Tue, 18
 Oct 2022 09:17:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: helenjethro1@gmail.com
Sender: carlpatrick934@gmail.com
Received: by 2002:a5d:5d0e:0:0:0:0:0 with HTTP; Tue, 18 Oct 2022 09:17:55
 -0700 (PDT)
From:   "Mrs. Helen Jethro" <helenjethro1@gmail.com>
Date:   Tue, 18 Oct 2022 09:17:55 -0700
X-Google-Sender-Auth: B7AVQo64iMN69TuwSZILGVRkPmA
Message-ID: <CAB5fAd9mizkxs+GSi070aFvjcdzTS3rrsKAvOV5cMOp_W6LAfA@mail.gmail.com>
Subject: Have You gotten my previous mail?
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If not please let me know for urgent matters. I am waiting to hear
from you soon.

Thanks very much,
Mrs. Helen Jethro.
