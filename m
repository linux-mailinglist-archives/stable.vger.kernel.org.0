Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF8B62E1F3
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 17:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbiKQQdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 11:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240280AbiKQQdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 11:33:18 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953767FF2F
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 08:30:41 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-36cbcda2157so23568767b3.11
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 08:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y6YfrDiAgG1F9juvXkCUy6r567+YV0JGLP3an+cEUOk=;
        b=jCJPs2AZ7cuP5j2QijeM2rc7SV8UeJApQMd6DffoRTcd6fkNQ9l+iE/Wi/ip9anNcL
         lWB1sCs5J6BHK+zh4Q6K/VjKa6VPZHpmJwa6nFh1WpU9bcvJ8Uzl7MdO13Jf2B+XR270
         5jpEd6kUE/HD/Vz6+yozTnXKwZb7RLxIww95Lrg57NX5uRnOHJkyEXEpqBwYCNuX3Pwn
         g/ndycnB6UOzvwzN9Fyf3q+JzUj0FgWi7/dTQgVf0iaYtwE5cgcLOXnbp+TK5KT7oQGG
         c0Vko96//QCRv7oXSSquDDbduXPp1fLJjX83BN2OInvN807v9iwWIn/tXQY+Gnp3Kucz
         YTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6YfrDiAgG1F9juvXkCUy6r567+YV0JGLP3an+cEUOk=;
        b=45rd2uHirDrRp2oZwI8Ux23E80Lb9eqtyjPqNYcRRauSzy0zxrBcPV8oGj68rWVibh
         cS+k17nWH3faj3TgDBZOjAkFMe3oQtmDse4GX7A5OWkpwsMjIdCWGO5ShGtS0+5JiS2Q
         o3JBXQxRm6fV0GEKEbcirWlS8nAg8tUPyDyeIZRnNPJZ/UOozMnOoRoU6MmqPN0MipoP
         uKPFbKb60QaD2xmILnx2wTaSI1rWr6KkLcY4sxdUHO0rrFpIlb45QX8W4j0ZDwu9fkp3
         aP/JIVChDEzjo1sPLaIXwhs2TDCTfkNVBXT5FtVj2Ul/lSbm655bZ0VjIQ0pCUgq55mf
         BNOw==
X-Gm-Message-State: ANoB5pk2tojPhIvTQy8kFPLgNiUOut00qgwl6Asev/rYkgRsFTIOpJLE
        GMb0vT5tSRcAK2afihFGMKjFC2au5+fj1VfPRDcmQEyt+rE=
X-Google-Smtp-Source: AA0mqf7hWqnkaR40+sElU/H1shdyebRg+cgBr5sUFw4Hy0rG3gUqxQxWxn0jlbxwXZNpJsnYBEBeVTroi7ABEgaUHso=
X-Received: by 2002:a81:5fc6:0:b0:36a:f032:5b4c with SMTP id
 t189-20020a815fc6000000b0036af0325b4cmr2773509ywb.114.1668702640714; Thu, 17
 Nov 2022 08:30:40 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:1b12:b0:306:6c70:eb91 with HTTP; Thu, 17 Nov 2022
 08:30:40 -0800 (PST)
Reply-To: jenny2likeboo@gmail.com
From:   JennyBoo <cynthiawilliams1098@gmail.com>
Date:   Thu, 17 Nov 2022 08:30:40 -0800
Message-ID: <CAB+y5kDPoj_RSNjvLP6SVCyb2+Ani0tKG-HS78-xvzZJ5V+DrA@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, did you receive my message?
