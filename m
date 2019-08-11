Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6DC78921C
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 17:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfHKPF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 11:05:56 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:33652 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfHKPF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 11:05:56 -0400
Received: by mail-wr1-f45.google.com with SMTP id n9so102607849wru.0
        for <stable@vger.kernel.org>; Sun, 11 Aug 2019 08:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=545DtWsuTcxZMT8/BCGD+hgq+QpW0kwGaI2hShK3gAU=;
        b=Clu82ZNyrKIx+rvgIY8sWsPf4hHp8kGSaHtgFJ6fbP/4z6jx53bf2MS+Wu3p7DwGKM
         5f7wMMs05etuhRE93ks4nJO+Rps39e+XZnqaCJ06hfwNcG834vv4d8vDW7TmMYKoJ5CN
         TyeYDn0GzznPMeXi68EuLQlCTu3zPj1gEJX29zZQXWYQZQ/fwsyiQ+Fqola/fKmONk3C
         aReQnGSvhizUwLhkkRFpuruVrkUasox9appycPJErRuunNinJ0N6nXmOy+XPSumWEx0a
         tAKs9cX0nYEfGQK3IgL/EaMfQA0nNKNUgd+5iI7a3XfA4LiLYPDXyVzMGkarxkIE96ei
         ViuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=545DtWsuTcxZMT8/BCGD+hgq+QpW0kwGaI2hShK3gAU=;
        b=c7XG/6xUoNrXhqQTGHte5rJLdjJZyjaU5Qe53c7Ged0i5lVf0tAEW0FxZeOGwiXFeT
         FkAgVRW9jVp9/8vhMOolD2Ov0iGCQ0RsOkxTAg7sjz/W66CiHnGzaZpen9WtcxyYhUQd
         G3to7JsMkcBwVKHZB7onf3IoClsgX9VttwrjWYPxly2FV+K/npXmcaD5XrGeUtTW8gcY
         eihq17Fsh3/+I+QAS1ZFJsELj1dHXJUPzTjaO3ggA1arAnv2DUybiHjq4psL4henztVa
         QCfTmKRsTWHOTp82BQtYFhz2IN0xAnWIexijC7/AYDHBl9vAyI5+Gjy135PX/+IjA/5k
         Oi7A==
X-Gm-Message-State: APjAAAUFfQHCW4IjV9HmvvzUtbAU5xXIg/d+VXXbq9IzZu0HnTeXVYpT
        NCQYaoBOLj543WJDhCRrBq22o0XYrI8=
X-Google-Smtp-Source: APXvYqxcZvm3igcUgrv4gFNsFOVFyOPdRSMeJ7YjK+KHDSA74J19ypZugkWyfJfROzr9CiHAOAOMcQ==
X-Received: by 2002:adf:c594:: with SMTP id m20mr38065375wrg.126.1565535954502;
        Sun, 11 Aug 2019 08:05:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v5sm166392620wre.50.2019.08.11.08.05.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 08:05:53 -0700 (PDT)
Message-ID: <5d502ed1.1c69fb81.5beb3.533d@mx.google.com>
Date:   Sun, 11 Aug 2019 08:05:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 49 boots: 0 failed, 49 passed (v4.9.189)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 49 boots: 0 failed, 49 passed (v4.9.189)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.189/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.189/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.189
Git Commit: 4bd718dba6581ebd392539ad659642552fb5826c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 22 unique boards, 11 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
