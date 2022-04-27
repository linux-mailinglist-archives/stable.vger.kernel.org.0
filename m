Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B72B511B84
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 16:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbiD0O7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 10:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbiD0O7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 10:59:23 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A80A7092D
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 07:56:12 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 4so2950339ljw.11
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 07:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hcsdovZexsweBQgXsrS9TmegcFHPxrc5+tTSlWIXW4Y=;
        b=Mk8ad1JmuUGu76iqUzj0hZOK4AWUwiFO/fucuz813H7p/GRDcUP5X5IlDJ/uqAwMzq
         7M/y6s8UtFhP0qbi9DkwKhiYLXpLI11GKiAOJ5nfo1H94Nt/7QLHLwwe390k5o5/9V6+
         CGkFskcg/015FQowkE6rjAyV+O3tqLUJXGorSYWUMb+0JtoHF/BAcZFr8ZXwonL9niCy
         J9jXwdsUU3pOaz4Y0hzWPBxVw3YJvIOmh4iatzJ0douLHS+Zqt9xqS5PJj0dCm8LwbK4
         BqZc5iGX5A68RN1TlZBpSktl65oHsTGS9bIKH7ZR6l8puFbkyv0pS7EXpdFvb/IJ6T1G
         18aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hcsdovZexsweBQgXsrS9TmegcFHPxrc5+tTSlWIXW4Y=;
        b=4VLQTAP8AiexlTr9x4cT7rSJ/srKirNSWxLPKRG+3rGliFrbejDUxhyE8L96yfKuFX
         rO+4vGxqhE3ZcEWVuNThKPZnhrjZ9884cZPaxy8tW3IcV8jBG6QoNkjAi8e4u03Ougjw
         j5zNbaKSGwp5mRV2Niod04DDbYj4/A3DCn7B1x6JOG94IfcREcKDISjLYZxlbf6bvlba
         3RItSHMjsqfWzHjNWvbIxYpR5E35fvPOvG5xZ5j0kl6VgTFmJTHJivVVa0GUECrrfwa8
         zatjI0uf85XDCTMU4yR+rrSTcIb8JRq55NCw46D4yv1XFfxxxioAIDxGHXgQV3J8LsqX
         zgRA==
X-Gm-Message-State: AOAM531FhxF2Ya7XQoutXVStDXvh1YwQt+GKgcEOJX80lQs71Tu9fSTV
        EwtGWENmXArEvN88nBZb1cMFbRBP+cgWwC0wZv/Ft5OGmIqBMQ==
X-Google-Smtp-Source: ABdhPJzE2HZ++oaPHg3uFGTZX5OfHCi+U9B4PYrvEp8N+xkC8YHpWP8G01Sf/2hZjvoDpzkwXOy422bSZs5UOslT1iE=
X-Received: by 2002:a2e:a54d:0:b0:24f:631:ed47 with SMTP id
 e13-20020a2ea54d000000b0024f0631ed47mr13912622ljn.372.1651071370745; Wed, 27
 Apr 2022 07:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220426081750.051179617@linuxfoundation.org>
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Wed, 27 Apr 2022 20:25:59 +0530
Message-ID: <CAHokDBkpJutmdyxAjBih-QL012EAGrUi0ucMo6f9SZuUJ4eLSg@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/146] 5.17.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     skhan@linuxfoundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regression found

Tested-by: Fenil Jain<fkjainco@gmail.com>
