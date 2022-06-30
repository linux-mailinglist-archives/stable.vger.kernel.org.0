Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F30561FC4
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 17:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbiF3P4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 11:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbiF3P4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 11:56:43 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02763DDD8
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 08:56:41 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v14so27940488wra.5
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 08:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=PC0C+IYmZqgzCw2evluP2hpSsCJzEX6s3IMX68ULD3E=;
        b=BaBLVelXBpLFsqzQgQ3dwPGYatiyVrEV0gCR+to6GD/WuZIV0KauB+ojWUZduhJTD3
         17ve757TrMQ8b72rrDdR8Fva+zyhK5zdgIQsIJ0KyDEM9vi/6/XWK1VwA/1L2uzC/RIt
         J/3FJ5qwJZd5Vc6fgkIQatnSGmJn/Y2bZ3+4wtY7iNpH2rrsi6Lcq3ULDuLzzwCUZaFB
         NTLWbWCbObzffiaf9Yj9XZOK+8V9vc1181YEycvDZRzUdwkTM+tXTzvv/cAta2B73A1i
         IBKpNM8UKRSqzl7hr/vHxdy6Z6N/rIw20tJ1+HeZ1PYYpuTatpgdCkwl22gNda5f//VR
         h7gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=PC0C+IYmZqgzCw2evluP2hpSsCJzEX6s3IMX68ULD3E=;
        b=ie3CryqJ0VshQEG9J/QoRoPvckuK//RX5B9GFnOzR9FEP4sR9oNWKgbv2lfNCCRf2b
         PeaN3S3KBy6C5F+rTi4bI/o7xlzhQ91MpcLQ0FeF1EKT5BwRtawL+ukPH11rbHk70gdg
         iblR1EHy2BiGbjioSyScb9+BmivA/8neQGqn+aGktKgRUjcVbjqSUcSjmRzgaYrA7DW8
         clZwoU0la8QOuYQP/kxbGgARnDtKyhU0MFQrNgCZXe0tll/Wa8yf7tEdzuYS2OSNyOjJ
         TI/9HiR2+lxkGAVOwKVa2A/h+JTYgX23WVjo7mcYGYUdGE51vBW1sOdk1ornNt5VAJE7
         dKTg==
X-Gm-Message-State: AJIora9n9UPm295lDRhs+IvDqQnFEh8eJmdK8ySv9MRfeQXGnKYgtrZX
        1IGbNSxUWvEDCkmGqF7ximE4uOLr+tg=
X-Google-Smtp-Source: AGRyM1spBoy7Nrnpedu0pR9eJCU2KsdB+wn4tmMYmljivtqOx89rj+O2MWThCPga2j2Q9Apao+OT+Q==
X-Received: by 2002:adf:dc08:0:b0:21b:bcaf:8500 with SMTP id t8-20020adfdc08000000b0021bbcaf8500mr9024570wri.133.1656604600268;
        Thu, 30 Jun 2022 08:56:40 -0700 (PDT)
Received: from DESKTOP-L1U6HLH ([39.53.244.205])
        by smtp.gmail.com with ESMTPSA id r127-20020a1c4485000000b0039748be12dbsm2898485wma.47.2022.06.30.08.56.38
        for <stable@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 30 Jun 2022 08:56:39 -0700 (PDT)
Message-ID: <62bdc7b7.1c69fb81.b57fa.65ed@mx.google.com>
Date:   Thu, 30 Jun 2022 08:56:39 -0700 (PDT)
X-Google-Original-Date: 30 Jun 2022 11:56:41 -0400
MIME-Version: 1.0
From:   elda.dreamlandestimation@gmail.com
To:     stable@vger.kernel.org
Subject: Estimating Services
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

=0D=0AHi,=0D=0A=0D=0AWe provide estimation & quantities takeoff s=
ervices. We are providing 98-100 accuracy in our estimates and ta=
ke-offs. Please tell us if you need any estimating services regar=
ding your projects.=0D=0A=0D=0ASend over the plans and mention th=
e exact scope of work and shortly we will get back with a proposa=
l on which our charges and turnaround time will be mentioned=0D=0A=
=0D=0AYou may ask for sample estimates and take-offs. Thanks.=0D=0A=
=0D=0AKind Regards=0D=0AElda Pierre=0D=0ADreamland Estimation, LL=
C

