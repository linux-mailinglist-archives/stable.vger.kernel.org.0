Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F2763B26E
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 20:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiK1Tm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 14:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbiK1TmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 14:42:23 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D36120A7
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 11:42:22 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id n12so8125359qvr.11
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 11:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :references:in-reply-to:reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ce0NP0yhJmYwKDNo+UsVVXfSEFkzNycw3c4cnkVJ6mE=;
        b=VWyA3QnQnIEVBhRbkZz7L8CaPHC1/fRRgK1aT2XsKGM3yCIjFuC8AweA9P2OOtxlRu
         GyI+GKy/bxdMxdTBFgBUxx8+Epq8Ot53aQGQdPSs1d7GV+6J1Jvbk0vPrNtg3W3MFznH
         62FYaRomfcrw8Ax0SnNkMSqsbANAjEPwMwPVoL2R4UXY8TLecETCYbFNSHvEuWcIs0qT
         2UmVs8G7U8E4s08I+lNhZ4QB6lszf2mroTxcrER4Wfl54S4VaNRIIrEnO78Wd0Z1W0P6
         IHDzyZb9TsrNEGXaS6WWhjIkR5jpXU4tVhG1yiH4w/LxMA7cfItoNeL5b+ZxKKKefhDX
         TVOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :references:in-reply-to:reply-to:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ce0NP0yhJmYwKDNo+UsVVXfSEFkzNycw3c4cnkVJ6mE=;
        b=Ge/17qsx5clIcPd9YekVyo5j7pDQZvCZET47NRzLXyDcyjLAwIi30KnSjZPyGxEiNS
         sXCU9ZtDWGCh33+9PPn8KnWq8aXDOL5T+oTvZGz2nqEuEn981/tSwJONmTM4P10sxsQE
         YDf3WybTYJ7i91OjoPa6pB676tn1U19doB0pFYhMnYgoIVbZn0JT+S5Omch3EJOMG76Q
         Q1WzcqRivENhuR9GtksydgkmAqbxumGfdbuywGle8VJ4xE4PCKH/22XBu4bwHSqRL3hk
         MPtDYtHPtG5h3f03v9smVWC3Es/lRrqO9KWpTUaSwOEMN20UZ77P0wUb6p+kqUUq9un0
         3puw==
X-Gm-Message-State: ANoB5pl0jjb2kqhcYuXnJwGjeIfitcHs7pz7LP5n0rG2pxI19qeQAweg
        xeCNH85Zpy81hjD62Qh/ib+OQN5J9pdDOGRLn4k=
X-Google-Smtp-Source: AA0mqf68PzjhrIptOkeFjjnEqF2HcNxsrsyT8nuoX2q1998LxF3g6g0jQ+p4E1XIRyJ/TvlHg7FmndIDYV3e2jXXa8s=
X-Received: by 2002:a0c:edab:0:b0:4c6:b483:dbb1 with SMTP id
 h11-20020a0cedab000000b004c6b483dbb1mr31953364qvr.85.1669664541978; Mon, 28
 Nov 2022 11:42:21 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac8:7fd6:0:b0:3a6:6ad6:4442 with HTTP; Mon, 28 Nov 2022
 11:42:21 -0800 (PST)
Reply-To: davidtayo2007@gmail.com
In-Reply-To: <CACoVRJT=aVCEJmqUmsPqQ7P4woV5n_Vcx10MLVYhMZALMGJKjw@mail.gmail.com>
References: <CACoVRJTG7nZ2mxUpA0jvjL3YhuiP4ONCjEmBevggGd3gbwWgwA@mail.gmail.com>
 <CACoVRJS+5_x09=moHsXbOnLFRi9drjGUjEpc=tbxzStBAMSAnQ@mail.gmail.com>
 <CACoVRJTsVZ0EOTGUjVvM=g-dSf28U6r3jvdGzAuEwAMvZ6i9HA@mail.gmail.com>
 <CACoVRJQDwTLJy5BmDQzKETf+AsPrwbrwgKNrJfWEKUq0KWtLVQ@mail.gmail.com>
 <CACoVRJRedtXCMuX5xKcxL-wGPMO3m9Sy_yydOB5kd+V5nhcM8A@mail.gmail.com>
 <CACoVRJQq_z-7SZnEaXbe9rDfNw7RyBMg4LgF1TJsqZRNZg2=4Q@mail.gmail.com>
 <CACoVRJTmCwddzUJs=ysoVmXgUROJ7JLNmpW1sLMDF4-fjk=RHw@mail.gmail.com>
 <CACoVRJT9QYpa99hm8chJr9Ay0cU8E3=73=ZW=mAHz-uzjhVExw@mail.gmail.com>
 <CACoVRJQoTKUi=AoiY-0sVqRauVK2gXM04yp--CD1VXeuyON=Ew@mail.gmail.com>
 <CACoVRJSNRAM-rq0crEgc0CPgBfX4ZSbmkrwG_TmR1zixL7qXvw@mail.gmail.com>
 <CACoVRJS0ncuZYD9Q6ijm7m5WKyW_U-yFxw8id4Vzy5ZsGbOqrg@mail.gmail.com>
 <CACoVRJRbv_6Pa9scnJNFH3=+2ghx0jA7BXvo3-8wvnHoTKJTUQ@mail.gmail.com>
 <CACoVRJT7WZb81gBWGLEDWeVCaXdg=Yv4ddBM8EKjNaLtDgJ65w@mail.gmail.com>
 <CACoVRJTb-x6GCn6rS2PHwhZzZ4kVLr9VU8r5Lh+YD1+BcACULg@mail.gmail.com>
 <CACoVRJT==NQVUaN1FSnpFdk8K17Zt75cVemxRFxpoaJTvQo1_w@mail.gmail.com>
 <CACoVRJQB-YCxY0bWvPXNt9S4DsCUHXyk964=uo1rzvAZx00avg@mail.gmail.com>
 <CACoVRJSuRY16B9KwH==gFQArzCMtyw4L6Mrrt9ih5DFRrK6Veg@mail.gmail.com>
 <CACoVRJRmv4ZqrfH6PkuGRswEA=WTU-NYZJMYZqHBRsPXbhDyUw@mail.gmail.com>
 <CACoVRJSHRdQ-F7DEjjN5HWc8vQ=DA6=L7RN3Gjo481NzAhbGgQ@mail.gmail.com>
 <CACoVRJRN6Da0mLYmmdzfu_wjaK_eCqKU36rCgHSnpB_iaYbAbA@mail.gmail.com>
 <CACoVRJS9oiwA+Hi0veRXHfV6RHJmSMtpJefdDpXS=LkqUsTpBA@mail.gmail.com>
 <CACoVRJSiky9H3VSCEFJNvUORMik1R812Mu4E-9FYFDRE2A3eMQ@mail.gmail.com>
 <CACoVRJSyeOx=1tJy5PjqKNGcEaMpE_GT_KMKJYGQgdhRKB50UQ@mail.gmail.com>
 <CACoVRJTWrLbzZLvgdHGNR0654wR42XDjko=YoTacTkVCjtE7QQ@mail.gmail.com>
 <CACoVRJQJYRnpqYs++63Jt8eyxPkrwQVTWvVfeMA1RuxsGutjiA@mail.gmail.com>
 <CACoVRJQMDzgHGovyx5=DD=kkvb35XzSowN5tTM1CSthfat5tYA@mail.gmail.com>
 <CACoVRJQ8z-bgnTkdPc0Lh9tM17kezRSvBg2726mK5MrcGwhbDg@mail.gmail.com>
 <CACoVRJQBDJ97-x5-0oxe-8EbsifOC=sts8tD5+KBvciUiChxsQ@mail.gmail.com>
 <CACoVRJR6BEr34ord90_=Q2SuPbnXefYOYvRqueVOjvsxW2gjrg@mail.gmail.com>
 <CACoVRJQj+h1mBZp-52FCAvqe0bG_7r3fbyRF5dMiCvoedye3=w@mail.gmail.com>
 <CACoVRJR9HNtB=F4DYFBVznus8jP5=5_rhS3EU8Rk_gZiBt7HUw@mail.gmail.com>
 <CACoVRJRFD6DDBgMhZhLjO5vy++hJ44P3RRTZueM=OU_YTOu0tA@mail.gmail.com>
 <CACoVRJStnAm8Asnn7Dcs7DF7k0BE_wH+sr3wfQpuNQRr5eOezw@mail.gmail.com>
 <CACoVRJRiB8iDpoSvagVd8BsZtaDA9O_GBy5tM9sznX0BH-Tm6g@mail.gmail.com>
 <CACoVRJTTjuCk-veLsBPF9ZTJALUKkxa2ZOqEN-MX6021MV_6DA@mail.gmail.com>
 <CACoVRJSV+pwVSK7jDP7+UXeWsffnL=n6SX4FJXgXFaYcETSpyA@mail.gmail.com>
 <CACoVRJRSnNMM6-=+XwH9PfF2ir7euPcewmY4AAAV-djzCH=xHw@mail.gmail.com>
 <CACoVRJSE2AMHEO08utzVjZrYMFXXo91TbSK2SZ7QKuS2wbF12g@mail.gmail.com>
 <CACoVRJQ0X6gDbaFLf5zVizd0rwdgEoT-C3X=DYWe0wG6p4BYbQ@mail.gmail.com>
 <CACoVRJRqRqMbtjh8eR3HkFHQPSjp1rqqN-tZrVjtMXLj6w7f5g@mail.gmail.com>
 <CACoVRJS4pByOm7uue0oN8SSkXdj_xHkWp9QLOG1-AGAtni1RgA@mail.gmail.com>
 <CACoVRJTTU12XQzZ9c_9fvwkO4bT3VP8inrdh5UjzzKUMw-2VDg@mail.gmail.com>
 <CACoVRJRBXS2=AKekhPP+uba+-Q5474vz7cJ1DH8nPCVYmBfo+g@mail.gmail.com> <CACoVRJT=aVCEJmqUmsPqQ7P4woV5n_Vcx10MLVYhMZALMGJKjw@mail.gmail.com>
From:   david tayo <matildamambo1956@gmail.com>
Date:   Mon, 28 Nov 2022 20:42:21 +0100
Message-ID: <CACoVRJRx88oq-TCOKy4-DFsN7VXe0iPSAOQSjpYOWkZmmmO6Hg@mail.gmail.com>
Subject: =?UTF-8?Q?best=C3=A4tigen?=
To:     davidtayo2007@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Lieber Freund

Ich dachte, wenn Sie die Ihnen zugesandten detaillierten Informationen
=C3=BCber den Gesch=C3=A4ftsvorschlag erhalten haben, wenden Sie sich bitte=
 an
mich, es ist sehr wichtig

Vielen Dank
David Tayo
