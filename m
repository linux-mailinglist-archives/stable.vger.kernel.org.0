Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCEDA4397D
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732262AbfFMPN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:13:26 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39021 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732260AbfFMNa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 09:30:26 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so10137959wma.4
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 06:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=fG7zTrGYhrTn2R8dicpGyyCWK8SjK6usqkrzLPnkewQ=;
        b=uCQaZyzX5/SinctvqDo8dFQ4w2Na8NlIkQzusQo9dViadlKq9VIwX02tHVDXpjt4UR
         fYujjVWR+GnxCIFsUXKKCUYndPnCBEjxUIs2osCBcFFPiDFaGFkiVwLpQL8MRUx0mQVG
         fky6mP+/FcwwBHuHGg0OugYptaDJ6jxyDi4FJ9ezUVV45icwJMINKGmeL3bpq2QzWf+w
         JE8RGTmqYYAYoSuQxa77CxEyRBZYjTbAyubo+2xxZDptGnS9RUsilnhteU+tnRrcZWBH
         Af8codS/S6Of1r9oDANWmAu8EYIfLzPbSj8PuC7XApzPdWOUsUkaC4qOQeRqd1PueFKj
         kZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=fG7zTrGYhrTn2R8dicpGyyCWK8SjK6usqkrzLPnkewQ=;
        b=locjiPrfdPru1JjknaF6kK5RHW5gcI4EWB6JO61CEdSXpp26Blboz+nEIgzJxD1CHD
         pQIDHaNCA1kYzAq2eRNWWB9GHcMDfDmllPr5BJ43vN9XakcSI8R16sBQ+5qG7DU5WcH6
         rh0oUAeJKIkr9sDk0yFvUKyR1nBhJrDcSy0AZvQDNp+VuxTF3d+hwF5MVB4VKPaWU3+t
         6qGom6PeN/VTQekkvqMCOJ3u3tyMQSfw1HklAXSVtnvPYnEfwB2xlFvkzrVAjFT4CluI
         gnMXUYt+u6ZHjO1f7huJ5hRDPq3TmxlfFMP4WaQQ7mcwJ+720fIQcm1MiW1Al8+JKpZW
         fJWw==
X-Gm-Message-State: APjAAAUgWGGIWvfCRkBXV6JO55Y+7BmlmNA0g/DrgdvVY7HNycbbEZqj
        a2eg2Hvnkc7wwSeFuhi73sumMe9OZ6TmTw==
X-Google-Smtp-Source: APXvYqwwjn735ZcJh4RCTzzb2yvw+vbpmotjGHKxj/HsIfwbG5bEALE3PPpaQAxEGGSxu1SyzuhDOA==
X-Received: by 2002:a7b:cb4b:: with SMTP id v11mr3844073wmj.103.1560432624540;
        Thu, 13 Jun 2019 06:30:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j189sm4337413wmb.48.2019.06.13.06.30.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 06:30:24 -0700 (PDT)
Message-ID: <5d024ff0.1c69fb81.749d7.81a6@mx.google.com>
Date:   Thu, 13 Jun 2019 06:30:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.50-119-g94ea812871ce
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
Subject: Re: [PATCH 4.19 000/118] 4.19.51-stable review
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

stable-rc/linux-4.19.y boot: 123 boots: 0 failed, 122 passed with 1 untried=
/unknown (v4.19.50-119-g94ea812871ce)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.50-119-g94ea812871ce/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.50-119-g94ea812871ce/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.50-119-g94ea812871ce
Git Commit: 94ea812871ceac0a190ded80c3272a779dfb101e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 24 SoC families, 15 builds out of 206

---
For more info write to <info@kernelci.org>
