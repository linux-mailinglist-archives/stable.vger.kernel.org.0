Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67028550204
	for <lists+stable@lfdr.de>; Sat, 18 Jun 2022 04:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347695AbiFRCf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 22:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbiFRCf6 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 17 Jun 2022 22:35:58 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7784D25F
        for <Stable@vger.kernel.org>; Fri, 17 Jun 2022 19:35:58 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id u99so10039983ybi.11
        for <Stable@vger.kernel.org>; Fri, 17 Jun 2022 19:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=dcwrPtXldcZQuaUTRubP/TsWaJ05MpxYEGzdke58B18=;
        b=RyN1fJs2lkbIaq470NWD+lc9AYpCjLn3mbDhd8WQ7/oDUnxUpyDFppTX4G1KkjUny2
         Pp93Cy/pSMMHhmRTd0XWKxcXmxl54c+kDlrbMhfm32TGtYqGRW4JaptiE3O/9UjuXfGu
         x7Mxs78UGDVGeWCGE7b7DDtm2kR5sb6futyaMyZJFSdehnc15qvq+Tp1Tg6IVlQpxTIj
         0baplhE+hqGcV6yk6FbomZNwnQ4T5rLZNzh+6CUoSIJSLdva4FLGuDyTq9hgsY64Xh05
         BNXmkhDQW+Yryt839wGdp3PvnZRfvZxr58nyDATvGmqmW5/R+2mxF/iGq4dk04N28VDV
         rHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=dcwrPtXldcZQuaUTRubP/TsWaJ05MpxYEGzdke58B18=;
        b=2dJivH9+EIRw7K6QBudNTH92VsdAFq1bIgSJxuW8bSLQ5YqWHNjpb5hSgQIdqlD7zn
         X9JTgEqypW02NlSvQvIooAVCzAZZ0lyZ3eZ6Df0pO8sdbT2wFDKPYdec6PgZAmRvEsw7
         htfj3ClOoUZSycpqasp5JwgKWQNX1Ofgh6bVxI4bu5s8fIUUW91m8UjYcTCSeAMlKAAa
         sRRYT+Cxt6F8y4whj2Frwec3ju9h8q3bOWlHafcppb+4vkl21dL7t3Mh5zDcRFOQL2Ey
         nUUd/+MSg/YkNjHfpiwcXPltrvD6DsP9uTryRgbH7atoaAxr8apJagvTgCeECW7lHsA6
         B48A==
X-Gm-Message-State: AJIora/O85DXGdBBy4A2yAcb2e9HWi7VKl8+5CgqV/eP5LRCRZN7KY/M
        j7mujTZKEMvxTVoeFvuJdAmsUCVSTpWIxEnFSmQ=
X-Google-Smtp-Source: AGRyM1tRAXV//gFdGnIxIcS61s+JL0QGV/lZJpfCuBbaY4nPUIBj6sG5jhR2wBoLPNABVr7e7GtMOKsg0pFOZb1rySk=
X-Received: by 2002:a25:68c4:0:b0:668:d0a4:fbfb with SMTP id
 d187-20020a2568c4000000b00668d0a4fbfbmr1091578ybc.313.1655519757276; Fri, 17
 Jun 2022 19:35:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:b381:0:0:0:0 with HTTP; Fri, 17 Jun 2022 19:35:56
 -0700 (PDT)
Reply-To: mrscecillelettytanm@gmail.com
From:   "Mrs.cecille Letty Tan" <smcpeterrobert@gmail.com>
Date:   Fri, 17 Jun 2022 19:35:56 -0700
Message-ID: <CAGzzBQ9s2ZtXSP=0079c4zzps3ZiGH7Df3-Qcd65VUC01KZtoQ@mail.gmail.com>
Subject: Hello
To:     smcpeterrobert@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

How are you doing today, I hope you get my message urgently, please.
