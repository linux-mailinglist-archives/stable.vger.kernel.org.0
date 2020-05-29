Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F701E7261
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 04:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404441AbgE2CF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 22:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391555AbgE2CFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 22:05:25 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988FEC08C5C7
        for <stable@vger.kernel.org>; Thu, 28 May 2020 19:05:25 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bg4so392255plb.3
        for <stable@vger.kernel.org>; Thu, 28 May 2020 19:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1WZNVSaadZVqMDwtVn0NnKD00+ypa94ERX/SU7Og7DQ=;
        b=Ir0eju0S85+3e/NRJyZOrlWeXAujkfYRoPp6MgvFSeFuJgtKyusIcxxdPEmtqcZD56
         R4oYYEiKZKYPPHKRvZKRAjn5WABt60uGmECYKE1cSv1q1zQzsucqF0dhr0Z9pv9kQtta
         PpLMVRYIDpnt3OSsMyduNy9jP7Hg1pnnxb8gQBTdAH+phb/FQYbMKtBlHDiPnwfFOyau
         Ak4HcZ2Ii4uYxJvKlgldL2YwdjJFW/qqRmiO3ErGvDhgUN1XxdZxMWzlafap+nGoQ72U
         R/f+RKZCWymQnNrCqnVAzJAoSgLwduGeKfrqcblak3xzbeS1DpvSOQ9q0vMpwZJl8KdY
         3txQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1WZNVSaadZVqMDwtVn0NnKD00+ypa94ERX/SU7Og7DQ=;
        b=rpVVhvqWEOuvidOm/zIJg0SJuyUGyvt2AAfVWbD0G5qWS2ALQOyfzGG7jGTDaOvAeW
         bTG5kEvkH9IWPhgmBeNJM9FENGUpAgZs4Y3tiONOtFUmGKxlDpNVmiefOsc3vH6IDmpw
         C83QDRY9kwditl36v9D8I4r+wH2eyPdgUFZ/M+R6e0AFCcYprf4nA7eCIxRJVM8uARK3
         M/Yfu/lZN4t+7LjxizhxLLYhpJRSAvmDks06k6/sScLIBjsgtzjUmzgYXbsv3RFGMzDn
         JGHJb9A2smQ1xU4jxhKETec5lbCfbzfMYU84hZAHHiwamfOevXZe/E/am+yDTHbtxjuy
         bslA==
X-Gm-Message-State: AOAM5311y1l4NcYMbO4LTUAP6qNe0C6xCBYgUfKKo5003NrnJP0p89v/
        yCoSaiWaaTX0n8q/URpYB7OaJ7pIHzw=
X-Google-Smtp-Source: ABdhPJz5EPzbARpUJURc2topQwESVnnL1lb03H1XbkG8OcHHgEhxs9AYwukE9v0EBc3MVm84X67lCA==
X-Received: by 2002:a17:90a:f994:: with SMTP id cq20mr7006126pjb.52.1590717924757;
        Thu, 28 May 2020 19:05:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id iq13sm6744851pjb.48.2020.05.28.19.05.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 19:05:24 -0700 (PDT)
Message-ID: <5ed06de4.1c69fb81.e4db1.81cf@mx.google.com>
Date:   Thu, 28 May 2020 19:05:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.125
Subject: stable/linux-4.19.y boot: 48 boots: 0 failed,
 46 passed with 2 untried/unknown (v4.19.125)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel/v4.19.125/p=
lan/baseline/

---------------------------------------------------------------------------=
----

stable/linux-4.19.y boot: 48 boots: 0 failed, 46 passed with 2 untried/unkn=
own (v4.19.125)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.125/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.125/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.125
Git Commit: 2d16cf4817bc6944a2adb5bf4db607c8258e87da
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 44 unique boards, 11 SoC families, 12 builds out of 168

---
For more info write to <info@kernelci.org>
