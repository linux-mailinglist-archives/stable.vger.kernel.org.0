Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB424438D
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392459AbfFMQaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:30:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44603 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392393AbfFMQa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 12:30:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16so2335018wrl.11
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 09:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=fbFJcCZogG4E0hVeCzNVPT+VFyUUm0Zv3ff/zggRHYY=;
        b=nC26i9JZniQCZC/cxtHX3spCrKHdGQw/wG6eftGbeaFS50K26skje7xVYYal3QjLyy
         hLPTDRtiG7DlPKoeF0lF9Er2i0uHz0iI2yNx+Av7Yo5iWpvLuFBDg6gl1/RPeIYTQScH
         jm+6FxTaJ3K4otAkUwc4N3wDGrxixX0744FgmJbk7gkweXPsgWUu9UohbJ78CJAttij+
         iq4WL7NW/oGdRcA1+xofjHY/zbBArzMk1Z87t421coV5fW0Q4O2XusJkXtXnm7A1p+EK
         emVX2QhkmwlPGW841InmZBl/jmjOOUoF8u2cPvgoaDC9PCmj79rfozcL6jJbw5G7f5rh
         cSSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=fbFJcCZogG4E0hVeCzNVPT+VFyUUm0Zv3ff/zggRHYY=;
        b=nHYvVVT8mgiTlgHOl8hQE4RgV9pbfyxICC5JvlUITd9qj5ZzniOwM/JYllCO6YO7qM
         uj4fQGoy8qbOE9iO6407oTIwvm+L6GEHV/AmBLkw1ZGf8zvxXnpZLuXeOUTjv2wr8vje
         RubzjYJYek0FdxU28iNTehcVpEckqOfGX09gmmbBD7QFpyYWoxajM1gP6iicOmtbdVXO
         RK7q3HkVk/jlYZUqJSejBA+ApivyaOGHMtlBSriiXcCxRf5BcJngMVjgSkWXKEjBtdid
         B3YitpBvdqS1GxuqSWI1BEnqHrWeSsE8cENjRM504dPbE3QhorUHnrjWA9Tk06P4Zd99
         BOtw==
X-Gm-Message-State: APjAAAXQL1i7fVpBmaAKHm/rqB+HlF16SwoN72b6lcydMEkEdlrnk4WN
        arvhtxcRxlM9Y58aR1HbP3CbpA==
X-Google-Smtp-Source: APXvYqwNQCbkcJmm/T/NHKOZkmzfBzdL0AsrgI/bKFEd3JLelxC5l8wP46eIXBRintpzIwFqS6LM9Q==
X-Received: by 2002:adf:fc91:: with SMTP id g17mr9205518wrr.194.1560443425582;
        Thu, 13 Jun 2019 09:30:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f1sm180193wml.28.2019.06.13.09.30.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 09:30:24 -0700 (PDT)
Message-ID: <5d027a20.1c69fb81.fcc4f.1023@mx.google.com>
Date:   Thu, 13 Jun 2019 09:30:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.125-82-ge64912eac71b
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/81] 4.14.126-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 116 boots: 0 failed, 116 passed (v4.14.125-82-=
ge64912eac71b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.125-82-ge64912eac71b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.125-82-ge64912eac71b/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.125-82-ge64912eac71b
Git Commit: e64912eac71ba57be3613c8fcc36e316fe8aa601
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 23 SoC families, 14 builds out of 201

---
For more info write to <info@kernelci.org>
