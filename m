Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E3156205F
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 18:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbiF3QgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 12:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236026AbiF3QgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 12:36:03 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A9D3B3CC
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 09:36:02 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id i205-20020a1c3bd6000000b003a1888b9d36so198217wma.0
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 09:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=21qz1Z80+Dw1e1d/lyl4lJ/UQsiXbri/GS0RbMTGIhk=;
        b=X52lBa+Y1ws5UViHP5DqtZ2NEPzwebZjmJRGx153iTcG3xffcFuwe18etXJRS9gXWI
         +KC+q+ZZw0ppRLaI7MZuk8Ni3Zl/SmeUVUZi/uJSvtBi01v9G3mAFZtaKLdc2Y15EGxD
         AaNLr9JBbPo+HlFveH5mM+/dxLOdvJ2JiG2vimlnHeffcneuU1muWgDQ/edC5e0zU9Cs
         nFoWgYtNkIpguGTmvsSEnNhyjaX7xsJeQSbM/jPYhC4m4qwgBEfv/aThSfe6ScJ8kaVt
         Cx321i8HC7qC4GUxogVsGVNontJT3y4KdAxq3sx/2YMK6pIARTEkOPVrYJrGZe7NKiyA
         M8wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=21qz1Z80+Dw1e1d/lyl4lJ/UQsiXbri/GS0RbMTGIhk=;
        b=fGFeXFkB37v5b6GfqDPu43pq3SSALuRNjPKLj799e54cRWEJHVuhMS62vP12lbyLVo
         E1l+oFAKHcSkxbauXWtssRoMf137zS+nF4tIzkuCm2Bp+YbtBP8VjaCHFZSUVsXJ/adq
         9HZGrbipPkJDpJDAkGS1ptNSEn+9tTbB6R5AUfXsN1oM0XC+6PENoqv03AWYUjTDQso9
         pkt9bKKdjhjSbc9dujC06QKjJHhfnhjYljzditK8euGTFPRlNAfk2C5zRmoEvvHCDiV8
         vzENo8+2NlhJlcbdkqDoFYq3zBjDrGhZKs5M1mY7ekXmwJmREPwyLkj5xItZyu/XDnhW
         GNLw==
X-Gm-Message-State: AJIora++cav6lK1Vni97ipEb7HLv6O7TWt1jaReU68qaW7T7c6839Lmz
        Gu1yAdwJVIK2ebuQfifw2mHPmJoVotH1qw==
X-Google-Smtp-Source: AGRyM1v1/4ncZyLPZ8luFKd3sH7NCGe4aChP0ft/nmy7SACFLxiemo9o4ZJ9F/wJmFxUaoNJA05XNA==
X-Received: by 2002:a05:600c:22d0:b0:3a0:3bb9:3936 with SMTP id 16-20020a05600c22d000b003a03bb93936mr13386134wmg.137.1656606960747;
        Thu, 30 Jun 2022 09:36:00 -0700 (PDT)
Received: from DESKTOP-DLIJ48C ([39.53.244.205])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600001c700b002167efdd549sm19611569wrx.38.2022.06.30.09.36.00
        for <stable@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 30 Jun 2022 09:36:00 -0700 (PDT)
Message-ID: <62bdd0f0.1c69fb81.e272.6079@mx.google.com>
Date:   Thu, 30 Jun 2022 09:36:00 -0700 (PDT)
X-Google-Original-Date: 30 Jun 2022 12:36:02 -0400
MIME-Version: 1.0
From:   rosario.crosslandestimation@gmail.com
To:     stable@vger.kernel.org
Subject: Bid Estimate
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,=0D=0A=0D=0AWe provide estimation & quantities takeoff service=
s. We are providing 98-100 accuracy in our estimates and take-off=
s. Please tell us if you need any estimating services regarding y=
our projects.=0D=0A=0D=0ASend over the plans and mention the exac=
t scope of work and shortly we will get back with a proposal on w=
hich our charges and turnaround time will be mentioned=0D=0A=0D=0A=
You may ask for sample estimates and take-offs. Thanks.=0D=0A=0D=0A=
Kind Regards=0D=0ARosario Woodcock=0D=0ACrossland Estimating, INC=
=20

