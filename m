Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84936CC109
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 18:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfJDQrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 12:47:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53001 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfJDQrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 12:47:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id r19so6541063wmh.2
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 09:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fHn5qitMgI5Bcn4qOQA1yeY5jRi0HZ3ocoW+czyGmt4=;
        b=qkfcNd8KrL94RmkB9eDtFpG5BqVzJ88rNoWAOcHrVqcqnjv3L/QinTpx6ve0kzEHsk
         WSEAsR8rNuJQWTDpZuhmPhR1FH41HNF+hYvj+M8b7UOXPDKtg3JFzqFUxv7653zI+u31
         ZBdOlVKCVtyOd48lu88RurPVT1048WnSOk/BEUEMCm8JWOV0BLVNWmMFos0z1P5jS3YJ
         yKo+JF8v7jYiP9jwdhVOpc0liNTQp7XMLRvQVJJmJqI322KhGLkVB6G5ALmLoXc8Pz3K
         E/D3tAY1tUwA7AWbbphn4dLb61dxNMQHDk1KdcgwS870l2L0h3WrKHl9DHS3FROUq1vv
         JF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fHn5qitMgI5Bcn4qOQA1yeY5jRi0HZ3ocoW+czyGmt4=;
        b=YWgZ0a0rhEmqncRSg02X8sE6ExHpQ8jD/E3pUKkVZaaGu7XIp4gDOmHYLrSXOzoj8R
         o7Jchj7eiLMC7A80wDu62K7lbaLaC7qF3KMKXTkhaTzRTN91hIBvoDjIJh6/6KoJKEjK
         jrZ5lYAfnmxZkz5IjZdbt0Ihg8n8+X5+sTAKqzvYkK1HJzOVj7uH3LmYhPrTJ4DnsJfN
         LP6Skgo5nurVq5Wez/TODqzIvdZOZK4LTgDAvs+UPt6kW9/dptoWbLSAdQte66uOeBDF
         YsH0gyQQY9IbKmDzqSOZ1IOY1iH3TXqVHuW0YID4TA+ySyP61VTX/2834mYk0TF3fu/Z
         Jphg==
X-Gm-Message-State: APjAAAW6cJjONsaNBDZkkaMhe8TV5nT208sg89LzE9QsvNw2jls1zSR7
        wqoeMZ0OFzAgJXQUzXT/B+1Sj6MmECUXMw==
X-Google-Smtp-Source: APXvYqxrvQn/SnfP2lQGePwcNnSg12kDAvD5M9erg2ow4NTwQHz8A2NUDUbtJubTA9KrO4HkMN8eTw==
X-Received: by 2002:a7b:c00e:: with SMTP id c14mr11188692wmb.158.1570207631536;
        Fri, 04 Oct 2019 09:47:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h63sm12520709wmf.15.2019.10.04.09.47.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 09:47:10 -0700 (PDT)
Message-ID: <5d97778e.1c69fb81.87fd8.bdd9@mx.google.com>
Date:   Fri, 04 Oct 2019 09:47:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.76-211-g407d81c4efd2
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 60 boots: 0 failed,
 60 passed (v4.19.76-211-g407d81c4efd2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 60 boots: 0 failed, 60 passed (v4.19.76-211-g4=
07d81c4efd2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.76-211-g407d81c4efd2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.76-211-g407d81c4efd2/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.76-211-g407d81c4efd2
Git Commit: 407d81c4efd2deaefd9907711da6aacdc77ac016
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 16 SoC families, 12 builds out of 206

---
For more info write to <info@kernelci.org>
