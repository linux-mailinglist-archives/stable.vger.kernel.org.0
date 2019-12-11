Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F1B11BF67
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 22:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfLKVvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 16:51:36 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42223 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLKVvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 16:51:36 -0500
Received: by mail-wr1-f68.google.com with SMTP id q6so303104wro.9
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 13:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/xhQ6MJKWoSlumRNJXm4RLO57l6PNrpucKWcnOTSYe4=;
        b=zHLeRxu/gHpLD+ObDn4JdyikdYHvrR+byAPzZ07RwxncTwDm9B02fPaun3G2MzZMhi
         wpucPHw++OQu0QdorhFwxwAwa9ucf+/86LjgaV5FfRtIta89b998230FKGgyXhzOUOsl
         t6mmxJySA/thbPa8bP+4BPHyAUXZ/mQyPpY6FlOwcNZdVKbwTvY8+xWhE6bpSx731s3l
         lkIKPg6oBDdFDm3796WSIFjijmVRXZfJo1aPvXcr4gHyRM1ioL8ebSZ4QnYkGUOrysme
         2KXTVO5F3Md+GhhjjY2Wnc6sKeX+UOtTGcBRrVl2sf70ihvVBpLzlRaZycU5qNLe63Bm
         jjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/xhQ6MJKWoSlumRNJXm4RLO57l6PNrpucKWcnOTSYe4=;
        b=FY5+7pv7Rl2EKcY6F8ey/wMdZxlljrSlCrAS1RBqSsE7kcyncWCgsWJMTuP3dbn7SC
         bWf7xMJug1dYi+tRGKw5DkiSii+eIhTHksQu1S60WwrrNXPJOm7b0kaOYdo3QRhdupD7
         kAdfvvaBdRpJiqJqG1tSeVlrziylI6H3TBbLQVK9DAzGbD//LClwazuZk6ui+cZoOAbx
         d9xsFhaq7yCMjK4+0cOTPpqoIVTD99GLuNZXW6mdIKh8/aDAchazuYL78Aet3RPUg82i
         rjxyxaMs1R4wM1ZGwhsDXjtuRFfd3qvz080fV+FC0RkWdE/6Vo/k5tPsKFZ4fSwGgLnX
         ab2g==
X-Gm-Message-State: APjAAAW5jSNRBsOMWexyHP2RZPTi+KNFFU0JVKtTTcDQItHOWOAZdAW5
        uOsBVVNCFV5eOO0p0+mEk31B8x7nKpB16Q==
X-Google-Smtp-Source: APXvYqy0Js4RhG1IQkI9/mLr52m+snknEBhwxy9XsmDH4+x5TxmAezjBwQoAEEciEUA6SP8QY8sDkA==
X-Received: by 2002:a5d:5403:: with SMTP id g3mr2156868wrv.302.1576101094461;
        Wed, 11 Dec 2019 13:51:34 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s82sm4033043wms.28.2019.12.11.13.51.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 13:51:34 -0800 (PST)
Message-ID: <5df164e6.1c69fb81.607f8.4b3e@mx.google.com>
Date:   Wed, 11 Dec 2019 13:51:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.206-93-g5974ba38392f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 61 boots: 0 failed,
 60 passed with 1 untried/unknown (v4.9.206-93-g5974ba38392f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 61 boots: 0 failed, 60 passed with 1 untried/un=
known (v4.9.206-93-g5974ba38392f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.206-93-g5974ba38392f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.206-93-g5974ba38392f/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.206-93-g5974ba38392f
Git Commit: 5974ba38392ff1d7e98cd1ed1de3a3ce77c9da58
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 31 unique boards, 12 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
