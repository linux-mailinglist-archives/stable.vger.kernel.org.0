Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660C251FD17
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 14:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbiEIMon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 08:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiEIMom (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 08:44:42 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBB61CA34A
        for <stable@vger.kernel.org>; Mon,  9 May 2022 05:40:48 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id dk23so26554132ejb.8
        for <stable@vger.kernel.org>; Mon, 09 May 2022 05:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=7RcKw958Dwoxyv5P28kdPCejyB/j1UrEo/6eETvtZeU=;
        b=qGYpeGmWtGQZbHGbMm9sLpMLQkNGoNSqYlyP6SnANSFiXA9leBKIu2JXiuaSqmR5H1
         yrOXhnxagtARajjFQa4Xnudxy4HU8xNjEBGc0ROI+1ZCCZAhoFNja7k5twLXbFvyezdg
         Aa1ZMCr90bwn+Jgnm9TjIv7r47XhOU9CTfYzaOWtWvPPPOMxpuPE+cw/uPB6ql4HAa/6
         ZEHk8ygoZCA/yRRtwUpytuuIj4hWnrM8gQbQHv8Ol2Ws0kYlG+5XUGAXzBPa3u4fE2BU
         F38lf9pPB5kyp90JBPzXcvVIVInUnT7ieIKLfDec40MRZ0g+Fw4cAKfSEY4I0YZmGQqa
         aMqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=7RcKw958Dwoxyv5P28kdPCejyB/j1UrEo/6eETvtZeU=;
        b=BSVYeyw4FG0k1PPz2zSL3v0RzwYe/mUYzW+7Zt1X7LHqCcBmufhU4sn+8+zRlRmTNk
         ka2njGNDDtNK+RWAE7EcRoo90tK3+7gShkbvJGXjtExsMvzFDstG/oUajaUu9mmrKjc0
         cBdCd71kGB2ep9qPH8HEPv5KPDhOXD1/gQfIaGiLpHp4gsrnqYaqt7YljLW97LF6Cjg1
         mB+2AwRWo1DLuXW6tJq1eJyMjL8sdGCgiRNJ6qD4pxLrhooXAQ2D73ppBuD4RqO+roxL
         0/TBNANCtKXSPZy0fb/v18Y/VPLnLXUJq0j42n6Dll8FidAXl5obgmwxad721xzf3VZX
         UNpw==
X-Gm-Message-State: AOAM53277Z/NZ84O5vAIz+vQoplg9iAn1KemRZ8rcD3bcnacq1DWI6AU
        l32hX7d/fUsR+hODpNR8BYlV0Z5I6cWRVVxSrYI=
X-Google-Smtp-Source: ABdhPJxn6LPNWDVRXhSG7NOx5dAGCj2dXxolchnPegomC4Su5yG99LF+hqv6FQim3VZPsyq1s7v49tVRbMlCJjD0KQo=
X-Received: by 2002:a17:907:1c0b:b0:6f5:64f4:91df with SMTP id
 nc11-20020a1709071c0b00b006f564f491dfmr12823927ejc.750.1652100047246; Mon, 09
 May 2022 05:40:47 -0700 (PDT)
MIME-Version: 1.0
Sender: franklinlometogo@gmail.com
Received: by 2002:a17:906:7146:0:0:0:0 with HTTP; Mon, 9 May 2022 05:40:46
 -0700 (PDT)
From:   ueoma <westafricaeconomicmonetary.tg@gmail.com>
Date:   Mon, 9 May 2022 12:40:46 +0000
X-Google-Sender-Auth: 97FZV2gAkxOyxvezBqDlsx2WofI
Message-ID: <CAM7APZxTEzM2E1ypATyhBNwkCiApGV5SUZfAhcfQyEH10VBWRg@mail.gmail.com>
Subject: =?UTF-8?B?0LLQvdC40LzQsNC90LjQtQ==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

0KPQstCw0LbQsNC10LzQuCDRgdC+0LHRgdGC0LLQtdC90LjQuiDQvdCwINC40LzQtdC50LssINCX
0LDQv9Cw0LTQvdC+0LDRhNGA0LjQutCw0L3RgdC60LjRj9GCINC40LrQvtC90L7QvNC40YfQtdGB
0LrQuCDQuA0K0L/QsNGA0LjRh9C10L0g0YHRitGO0Lcg0LrQvtC80L/QtdC90YHQuNGA0LAg0LLR
gdC40YfQutC4INC20LXRgNGC0LLQuCDQvdCwINC40LfQvNCw0LzQsCDQuCDRgtC10LfQuCwg0LrQ
vtC40YLQviDQuNC80LDRgg0K0L3QtdC/0L7RgtGK0YDRgdC10L3QuCDRgdGA0LXQtNGB0YLQstCw
LCDQuCDQstCw0YjQuNGP0YIg0LjQvNC10LnQuyDQsNC00YDQtdGBINC1INC90LDQvNC10YDQtdC9
INCyINGB0L/QuNGB0YrQutCwINGBDQrQvdC10L/QvtGC0YrRgNGB0LXQvdC4INGE0L7QvdC00L7Q
stC1LCDRgdGK0LLQtdGC0LLQsNC80LUg0LLQuCDQtNCwINGB0LUg0LLRitGA0L3QtdGC0LUg0LrR
itC8INC90LDRgSDRgdC10LPQsC4NCg==
