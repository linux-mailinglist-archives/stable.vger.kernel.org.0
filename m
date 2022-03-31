Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846FF4EDEBD
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 18:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbiCaQ05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 12:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239944AbiCaQ04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 12:26:56 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BBA62A3E
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 09:25:02 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id i132-20020a1c3b8a000000b0038ce25c870dso2012342wma.1
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 09:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=SNHHRe2ZzSNGPseirROJTlFiRpkfoRkugNhNQv1nRKk=;
        b=TYOGU/ZfLU7AmCBv9AItThNPJH0hwAxDmt5kPcMXrynxQINxmV/uAL46XeVVwldErO
         lYlbNXC3IdL7jg9uMuGg2TEKCr5UBze0sVJ2MaFrzXrSduP5DcelaH5Tk636Rj6323zy
         fDIIyj/kJm5h4z2N/ZCjY7BuIB7u35oqyPbFgDp2m49BRaicBWmQS+39I58MPXttdbmV
         Bt910ZYO2olcKjEEL+XvpdIPDwHexl8+yPsc0ImcWlzhy8w+m5UV82KLwnH8duQ7gpYY
         Vnz8PM+hFqaOBtdlOroGXkmULrrbG7uDVxDhhU3iHHRk4hQYeiyM40SxxwRh6+nnbScB
         91dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=SNHHRe2ZzSNGPseirROJTlFiRpkfoRkugNhNQv1nRKk=;
        b=wSe1X8hJoqx1n2w3AYD5mT0CT27bmHZn3cpWBwg9Zhzrb1lmkr44URYs2lSmENGjX9
         7PJPzJL/JQWByOKalPSWaG61lmOF6bDs6zZFgC8l/iEc72sO2bubPQolH8hy/ThTdV6C
         YTVMCakdggae+mW/50WyEmc9grfF7CYEtgMAcMj7/2e6C14zjFYmxVSlSNLenFqWs6dt
         03JhakfqNMw8jg+A3KMv5ou2OK5+aWghk0G17ru5hNSIJiBLzBSlLdhtKOPIvDHaoO4Z
         MuOzdcw4PFCff/iL/i0WzGX8Li4iKfsigGMi3XUe6rFcBiJr1JIEonT8rtLMvSt+T5aA
         2buw==
X-Gm-Message-State: AOAM533yhpUp0Kkt0xObcxRPzvq+7UJ6kbme8XAXs5EdFete/FxP3kgp
        lZhpSuGDvBRLzka+rV4lPqtuXi0KjSfqbw==
X-Google-Smtp-Source: ABdhPJzuZTLrVWVCZXh2cxPE8cCFd2FeAHiWNca/DS9iU4i7RTE9zhOcIc0fvevFFsqjm+CQfr3Qiw==
X-Received: by 2002:a05:600c:26c1:b0:38c:b319:6d75 with SMTP id 1-20020a05600c26c100b0038cb3196d75mr5389034wmv.120.1648743900570;
        Thu, 31 Mar 2022 09:25:00 -0700 (PDT)
Received: from DESKTOP-R5VBAL5 ([39.53.224.185])
        by smtp.gmail.com with ESMTPSA id u12-20020a5d6dac000000b00204119d37d0sm21138083wrs.26.2022.03.31.09.24.59
        for <stable@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 31 Mar 2022 09:25:00 -0700 (PDT)
Message-ID: <6245d5dc.1c69fb81.16f19.4de6@mx.google.com>
Date:   Thu, 31 Mar 2022 09:25:00 -0700 (PDT)
X-Google-Original-Date: 31 Mar 2022 12:24:59 -0400
MIME-Version: 1.0
From:   nickolasdreamlandestimation@gmail.com
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

Hi,=0D=0A=0D=0AWe provide estimation & quantities takeoff service=
s. We are providing 98-100 accuracy in our estimates and take-off=
s. Please tell us if you need any estimating services regarding y=
our projects.=0D=0A=0D=0ASend over the plans and mention the exac=
t scope of work and shortly we will get back with a proposal on w=
hich our charges and turnaround time will be mentioned=0D=0A=0D=0A=
You may ask for sample estimates and take-offs. Thanks.=0D=0A=0D=0A=
Kind Regards=0D=0ANickolas Casas=0D=0ADreamland Estimation, LLC

