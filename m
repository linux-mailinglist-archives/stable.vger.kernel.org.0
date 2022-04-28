Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F309513EED
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 01:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbiD1XQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 19:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiD1XQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 19:16:20 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF21C0F
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:13:03 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k2so8635241wrd.5
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=IrIMxvMiuqD7E40ngqJ0QM5vqXpFgKaFTcNZv5ptaXs=;
        b=q5IgS4XVglPJlf3xznk5UvIheA60zO+C3laIXcqmY8/DrKCERZcFgXeABDVtFPlHzg
         q3u0mbZwqX2kOCarRdx4qXiQouFgEH5dpAu0FTnqL7hY+JuXAOkcumzoxEMmdAOpjFmg
         o7+sEVSoe9B4Vl6Qycw82c7h0z9qOJeBqsVVA0pGTFFA272jQSNu7IySxFl/e2nnpXq9
         lwK5gKePhXSn00nrgVm1iYJG6seHCA6Ym+HiugSlnC+Ji3Sov3nP7TGHldJtATwshsz/
         1fie1EIvo+hPj77tWdhgGhPq5+kKQJ73rZReEydZh4qRalCHOTQyecNx8TGtActxOA2x
         7ggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=IrIMxvMiuqD7E40ngqJ0QM5vqXpFgKaFTcNZv5ptaXs=;
        b=v6raKv3heHhIYOooHJ8kmmyPCobwkYYKIVWLXbxad5RgQuVBygNoYVauuyp1Aa9MB9
         79vwKVg5ZjCVws1Q3IrIel/lFyH5ui80xBFV7ocxC03+5iMqIT8HwjRQQQBXY7LL0K0W
         qcmpu4RD15wiyOA7pA3cBIBzA6MW9RGa9RDfnA6457rIjJ8UC5AHA/x6WZ2diwKnwjGL
         6d8kMSeUIULnf3GGfdjqTJ+5ORHR6n4teiiE1s/aUh8ciR/mGY2eS5ui6gszlgkADq7h
         sWHPFCBL3QoNNNEfVMJIU1zVZ0lFbEljIYINzeDxzR2BjAscHX3r4u0UgrSRGP9BFF9O
         rnIA==
X-Gm-Message-State: AOAM530gkUfvVKeebZW+FCwV7x/pk2qIaa2WdtJ1rlQEPy1ghdor/MXv
        KHuGChCB8Ez/Em0dEAQe8pWZo/4F7LIpLygTpTgsj+0yZ6BlPw==
X-Google-Smtp-Source: ABdhPJyxg3YWpYDGlnJYH/CTBZPOKJFL/3cwt66sp2sk4oBzaGRSeWAApV0LaqTWxNHLRjqRbdSACfA9O9FXp4vzqzM=
X-Received: by 2002:a5d:54c4:0:b0:20a:d2ea:1f7f with SMTP id
 x4-20020a5d54c4000000b0020ad2ea1f7fmr22712332wrv.306.1651187582399; Thu, 28
 Apr 2022 16:13:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:6dc6:0:0:0:0:0 with HTTP; Thu, 28 Apr 2022 16:13:01
 -0700 (PDT)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <sylviajones.usa1@gmail.com>
Date:   Thu, 28 Apr 2022 16:13:01 -0700
Message-ID: <CAA0-3mhn3trWgEtuWTEa+ZBrkvAq8+_T4p_oFd_DrQYxj32TWw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello how are you doing? I want to know the situation of things over
there did  you receive my message?
