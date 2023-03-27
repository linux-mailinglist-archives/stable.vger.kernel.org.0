Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFD56CA2D2
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 13:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjC0LvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 07:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjC0LvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 07:51:07 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9728B2D68
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 04:51:05 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id dc30so6752509vsb.3
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 04:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679917864;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eHcb3LlHc4qdRuXVD0Y4ShMJKX95lUz5nmbcdnXGwVc=;
        b=zO1lhzgqReRYOH5AkV6JautDCf/8/0wpqFCP/+H++l0n0zwZZjR0ucORWeXn6crhJI
         XG3dR6eCUjHHFUxVzwE3GUrvlMUrEmtCvcogAKbKB36k3Smy6iHV+cJeuVraBkWvnDXe
         azOXfaxE6MMjangOLkXA/s3nH8mafC2R2NJ5YcOflXV5B9FFKzB/IR0bJVdgOSRYVmRI
         p5oGP23L1v2wKx2b5lSDSu1D+ywLuDblmd5XrF0jsl/vQwoM78xTtSkTF+MUMRFIuqhg
         JuD3l7LwO6xD7vmqa1TygYZj0ORAnNH20FS28ObBhmitQOapTg48brQZhGpCg2Lenz9t
         zGfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679917864;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eHcb3LlHc4qdRuXVD0Y4ShMJKX95lUz5nmbcdnXGwVc=;
        b=WovjthgRrVr6WgqryhqGKHBAZldt2ahdALNl0zrOm9BpGbmV9ia+fcxkwivxcivlFD
         Jkkmvq/XzdXh4Ey/aJqmZW0YM4RGv13fo95cf5cUiwa0bgSpci4krrhKzTKtZWv+KmMR
         hmLxvHUaGt+hHC22ccxaeWd8yqfM/Er5dv6mC2DUUhOultzaP5RtiHOknXO4lxexQe5e
         olrZW5mOc+e7rTH8EUmvUIWozB8+hYgE8oSGJRmHCq/TqnR8l60QQL8KmGtI9PX0AcVH
         WOsAKZh+XPZMQFjNGlOo34KQZE6c2xJVQnOGafr+mb9FG9AKuqx97w0SgiZk/8FGus/a
         TvNA==
X-Gm-Message-State: AAQBX9dcD8WU7ZqhVx7wnCQpfswyferGXPu2V/4Rm6TInzVOj1Mp/8Da
        5X1Y8AVlJrzxl3go8hAnlLxElOU9iuYvD4kGjfTthtj8oy7DvkC6jJ0=
X-Google-Smtp-Source: AKy350Yfj22kBwJdgxbKlaUrmpfpqtVspvMhoG5GGI+tqp1YEV7eBML5NCDQ4+BeiTmSjp15d4sKQ/4+QUY1fSaQAhI=
X-Received: by 2002:a67:cc1b:0:b0:412:4e02:ba9f with SMTP id
 q27-20020a67cc1b000000b004124e02ba9fmr5882609vsl.1.1679917864190; Mon, 27 Mar
 2023 04:51:04 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 27 Mar 2023 17:20:51 +0530
Message-ID: <CA+G9fYvSEjPha-afNNG1oEn+-UoghyU7J3Lbp48F0SBpjt0siw@mail.gmail.com>
Subject: stable: queue/5.15: drivers/interconnect/qcom/icc-rpmh.c:221:9:
 error: implicit declaration of function 'icc_provider_init'; did you mean
 'icc_provider_del'? [-Werror=implicit-function-declaration]
To:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,LOCALPART_IN_SUBJECT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following warnings / errors noticed on Linux stable queue 5.15.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:460.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:460.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:460.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:460.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space

drivers/interconnect/qcom/icc-rpmh.c: In function 'qcom_icc_rpmh_probe':
drivers/interconnect/qcom/icc-rpmh.c:221:9: error: implicit
declaration of function 'icc_provider_init'; did you mean
'icc_provider_del'? [-Werror=implicit-function-declaration]
  221 |         icc_provider_init(provider);
      |         ^~~~~~~~~~~~~~~~~
      |         icc_provider_del
drivers/interconnect/qcom/icc-rpmh.c:257:15: error: implicit
declaration of function 'icc_provider_register'; did you mean
'icc_provider_del'? [-Werror=implicit-function-declaration]
  257 |         ret = icc_provider_register(provider);
      |               ^~~~~~~~~~~~~~~~~~~~~
      |               icc_provider_del
drivers/interconnect/qcom/icc-rpmh.c: In function 'qcom_icc_rpmh_remove':
drivers/interconnect/qcom/icc-rpmh.c:276:9: error: implicit
declaration of function 'icc_provider_deregister'; did you mean
'icc_provider_del'? [-Werror=implicit-function-declaration]
  276 |         icc_provider_deregister(&qp->provider);
      |         ^~~~~~~~~~~~~~~~~~~~~~~
      |         icc_provider_del
cc1: some warnings being treated as errors


Links,
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15-sanity/build/v5.15.104-76-g9168fe5021cf/testrun/15903892/suite/build/test/gcc-11-defconfig-lkftconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15-sanity/build/v5.15.104-76-g9168fe5021cf/testrun/15903892/suite/build/test/gcc-11-defconfig-lkftconfig/history/


--
Linaro LKFT
https://lkft.linaro.org
