Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA98E659B12
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 18:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiL3RtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 12:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiL3RtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 12:49:03 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6498E1A380
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 09:49:02 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id z7so9179312pfq.13
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 09:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Ty3ty9CtH9Tlekvr6o1MIyNdW39Ba6vq08cX235Uh7c=;
        b=v0EvG8IbKhBMBPhWk4RXNdARZ173cepBgq7nfz6FHUenPb3nPI+jphMKpCC/dJ3dwF
         /+mP2fjJokxG8j3wTEqD9ZcxP23cBgH1mGo2Kp29FYEcvNeAevE6PDo5aBOqtAlkc3ie
         z+RokhVXtXofKifiKxmJRQC1hi9bbD8s5Me8Nw5qmZYUeQ7/dMwqZ2KbuKkutLN/itBr
         C5X0sbSPttRn7xdXUiuepJnNQFmtp/qyONMiSgQyw2xZEmJNw/5AAhp+NpGalwAKbLKb
         u38c9Gs6HUML/Ch7a0fIVFgugNyAkwRk6c8xg7pitAiGlYgwpaDOsYEOvq/GYCjz4Kvp
         nAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ty3ty9CtH9Tlekvr6o1MIyNdW39Ba6vq08cX235Uh7c=;
        b=AYfLWaGopZf2a4E/OIgFQRdthzJLhlp3gfJRSDi3symN70OVLZ49mRwWbMVXjp4NHa
         nw7zDZHptqsX8PcFJBPDFkfgosq7LF1T7zI6VAc8mxvwK14SjsArJX1KqNAHtBEZk+er
         QMoB78et/H7GGEYLleRzvpptj/FrmiMByXO8iUtNgKMw4ZJ2koW+YPyqP1MWgaDHAZNQ
         HDDZbwBVLs0XBVOpHNju4lLDZjn1HlhzrwB3hhuJdzRMz8PplvunMNqRnoIO6vrNQRuU
         Zf3BkAZwFwo7OVIKesbRWINB5CO3RBCmjkV4+kdazFySr5f1mafQtREwi8gjSXSCRXBM
         Y01w==
X-Gm-Message-State: AFqh2kqsOT4cT6TGJwOLnpesFrMPODIZOsQji8pQnk1H+Vbct8wgWhXV
        T9RRN2DGw688KTYWwKNVmBsQF+NuPLfLykzBh9o=
X-Google-Smtp-Source: AMrXdXuLHHEr9e4Z4jZCB1aw9c5i5X2kkwOh/5EI3TWZr2aBPlOoqndpAkqzIzrCIJLlZ0S0w9lYxg==
X-Received: by 2002:a05:6a00:b91:b0:581:6f06:659 with SMTP id g17-20020a056a000b9100b005816f060659mr19150185pfj.6.1672422541699;
        Fri, 30 Dec 2022 09:49:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n29-20020aa7985d000000b0058095546a66sm9579538pfq.101.2022.12.30.09.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 09:49:01 -0800 (PST)
Message-ID: <63af248d.a70a0220.4fb2f.f527@mx.google.com>
Date:   Fri, 30 Dec 2022 09:49:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.161-574-g513553bd32507
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 130 runs,
 1 regressions (v5.10.161-574-g513553bd32507)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 130 runs, 1 regressions (v5.10.161-574-g5135=
53bd32507)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.161-574-g513553bd32507/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.161-574-g513553bd32507
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      513553bd3250787a1eb3b682f5fed011aa5e5035 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63aeefbdf3688586054eee4c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.161=
-574-g513553bd32507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.161=
-574-g513553bd32507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63aeefbdf3688586054ee=
e4d
        new failure (last pass: v5.10.161-575-ge87ac839390ae) =

 =20
