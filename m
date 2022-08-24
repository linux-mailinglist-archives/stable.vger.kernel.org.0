Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216E35A0351
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 23:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240261AbiHXVe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 17:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240133AbiHXVe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 17:34:27 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D851C5FAF4
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 14:34:26 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id h1so9338617wmd.3
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 14:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc;
        bh=fEubN+m1ci/TPKepgt3hibfV42AocEyZ3pmrb675HwY=;
        b=OHdHGPKHWamnHx05AJiAXaGq4Y5SSWOy9tUoW3Hh1YazYch3yW8/Hc0EVDUs58A3gG
         daJdgvy/DjxgnFpWeaXnJnOINls1E6HnvgTtXsYHNpm2spkNrRqS8i1oueFyhroQsImA
         JNhz6u6phQmQ7H/YGR7Zlxi6cqvjOP3QwsF7vXcOrdsR4bca4E82tcPAm3RwKGhSN7QV
         9LHe21bjGR91fkCQbksyy0I1dS3N0rEcBYjaS3CvZt23Wn2VIzFpAKrmsw8IzJrJ5wSf
         i05zzCR/7kkgf6d0U9CyVmJCEj8upf65PBHchGYMwfsJQIJDlXRnbgAutSad7TUETOMT
         pVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=fEubN+m1ci/TPKepgt3hibfV42AocEyZ3pmrb675HwY=;
        b=dOv7qWW+VpX/5b8DsGpLUwHrClWCcJPfJDcFfPZGRjcStnCetVnsl0ZPtL+Fee7J6T
         Hr7VAKKGyFWloUC5fHYCbWS1HsZerGLnMU2idBJ9030ZlOCGpcf+ZiYsAgAF0mvFwD9p
         znsF4x8PRuNSa5QV6TB7ffScmTy+wAMiTQuLSdi0mdZ65aiLwpv5L2BHaPxvpZ3QdMN8
         3zOM2NykO6c2q+IQRVXlnTZKjBDrgOmNnc7Xvpwggx3+ogIdj8gaTbE2RxOOKNvoHBLi
         J11pM1Uayp3+CAqfUe2HcarceMQtgX9RB9ZOKihyOEQhWJQoOE4LtW8VmSm3ioWIJAR9
         xfug==
X-Gm-Message-State: ACgBeo0eslNnLonUmvtOPvsax39wSLjhQqahRxCtHNNy+QoPlKHsLToL
        w8OcRlkR74CWkJ06LR1FdGg=
X-Google-Smtp-Source: AA6agR6/Ct789rlUG78hTeFByDOKd1Y3C4TjWs1QIse2OUHY1LYlBBObTz7BhEF9oPq7Mb2yVvw/Yw==
X-Received: by 2002:a05:600c:5008:b0:3a6:1cd8:570d with SMTP id n8-20020a05600c500800b003a61cd8570dmr388092wmr.57.1661376865458;
        Wed, 24 Aug 2022 14:34:25 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id l23-20020a05600c2cd700b003a6632fe925sm3418690wmc.13.2022.08.24.14.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 14:34:24 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:34:23 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: patch request for 5.15-stable to fix gcc-12 build
Message-ID: <YwaZX/nl4lsadXpF@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

v5.15.y riscv builds fails with gcc-12. Can I please request to add the
following to the queue:

ee3db469dd31 ("wifi: rtlwifi: remove always-true condition pointed out by GCC 12")
32329216ca1d ("eth: sun: cassini: remove dead code")


--
Regards
Sudip
