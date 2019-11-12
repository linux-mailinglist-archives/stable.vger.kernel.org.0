Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6CBF8538
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 01:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfKLAca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 19:32:30 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:39043 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfKLAca (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 19:32:30 -0500
Received: by mail-wr1-f49.google.com with SMTP id l7so5014998wrp.6
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 16:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y/jVYGtxZg2Ebf4c7TXEDOcUo7LeiKLrXWrF4K3+Nus=;
        b=gs/tbt6DpFGA5tRP35EDdLr6cxTlTzVVDya/AYeoeGKyJatALD/Z+LIGTZAzJa9ruR
         cbOupkuTZqzO3xWr6U+nD2OSiInc+OBBYUAx4aju20vFxCtMYAbn/zvDTryeCFqBcZ2s
         o7vtX6Dz+Ck/T1O63BeUOlxtpqx7+HK3QXpKu0Go5kg8034I0RJKeAgssawfIhTZkoGW
         u01iOt7xbEbClHclSj8Pd1FlAWPPIwtddpNIGZQaMJeyjLSXzXrvG5ONykydaFiqdN0+
         cBzzee/CCjzWkYhnkCKCREKXInyTXQgX3yPpy2LmuwmxRxde9Vwd07k12jfPV/oGl/oG
         mbiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y/jVYGtxZg2Ebf4c7TXEDOcUo7LeiKLrXWrF4K3+Nus=;
        b=PMeTavsqIwilLJR1q4ewTm9L3Bb0flbZdVwUMBbEuFGtv74VO6YX6UvgCMDdpC2w9h
         pjTUAAxPHQVYFkf0qXc3yi+2MXsutdqzwgZ7dtNhuW2xuME1ylEMHZpebr7PZrteKq4h
         s1SMNvAU3SFsI4wzcIB9GkfdXDaeIf9TVzTCvPuVzFxTQzb2Ut6LeLbdCWOuU//2QhLo
         dgSBPWE0RI+xZ1nYaqd9xkF52Us5ynWmp4ArTUr7r1ushofhL6bJwyftnm9ZWhRdZOX3
         xPMiYZici6zgLX6WjdTklLZ9KlIi3+VeCN+/N0jZI0PeJELzZRO1KJpWSHounEjShfQ0
         0WoQ==
X-Gm-Message-State: APjAAAX8d70hTnB35RPH/GczFltNRfkQELSSNylmPYsAv9QmuIPYGo1Z
        zmMHWhEviFDF/rMOp4l8HtrkJFZzCjdMoQ==
X-Google-Smtp-Source: APXvYqwHssZFOYeJI7jfg1Y3vy1jWoxbJbuYGOKU+Q17rc82HdaU4OeHYW6eywtQeT69EwllZwQuSw==
X-Received: by 2002:a5d:640b:: with SMTP id z11mr17398724wru.195.1573518746155;
        Mon, 11 Nov 2019 16:32:26 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g5sm2106570wmf.37.2019.11.11.16.32.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 16:32:25 -0800 (PST)
Message-ID: <5dc9fd99.1c69fb81.ffbf3.9194@mx.google.com>
Date:   Mon, 11 Nov 2019 16:32:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.200-66-gc28abeb7953e
Subject: stable-rc/linux-4.9.y boot: 48 boots: 0 failed,
 48 passed (v4.9.200-66-gc28abeb7953e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 48 boots: 0 failed, 48 passed (v4.9.200-66-gc28=
abeb7953e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.200-66-gc28abeb7953e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.200-66-gc28abeb7953e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.200-66-gc28abeb7953e
Git Commit: c28abeb7953e9602995ee83594fa294f54c07a35
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 12 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
