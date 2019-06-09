Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACC5C3A462
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 10:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfFII5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 04:57:00 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:51185 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbfFII5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 04:57:00 -0400
Received: by mail-wm1-f53.google.com with SMTP id c66so5758418wmf.0
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 01:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P/kl7deoirdW/hFQPKTXqfn94ik6xmDjISe8N/E0n2E=;
        b=X7hN0Tp1clTA55wKvVRPDDwtbiVFvV80aLwJWPUZ6DUtB8mmLt3KkfPdG/aJhi5Es9
         F4TmEsN13TQwMMAUXb16Lu/Qgt8Ivkj/jXcP3ieporMVMj5C4OlCSRtkU3R1vvqxF/Mw
         OXKpkvxylu2kxkVeLbIgeA9i/P38spERbRzjuN66CwpttefUeAddyWyIv/xD/9mE/W8e
         u8tf6zVvi9dRYEayf0WjoWPAkLWjnVgWiajT89JLjnf/JOQkau5nw+kLrvegAQRUkfF8
         GZCgCpbyJ0m4YdMM8k13x5qKyL8fK8zPS5nnbB9O8eqS4KBugNJBFinVuv4cyc5M6LLN
         YxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P/kl7deoirdW/hFQPKTXqfn94ik6xmDjISe8N/E0n2E=;
        b=UrNaUVZ7ZdO1tmE8PdfKrcUULId8F5Wo2+togvz/xv3FPUSTQb4PX/YWttRoRPvDw6
         42i1Lx1r/uaUEe6IqzDl+J6rt+Eu0OJjlgze7NCazWXhpTvUztilnGueuI5j7BWsk4kN
         voaMLDl99GLttdbyKjf7UKqwS/X01v+JnAw0IPDuoFLvNVRpd0MzYPd1ilARTx90gYkj
         R/qs8SThDMyhCrVQEWObCT9vS+nsUU7fDCa/Wt1HIi7QYfEtns4dcAdelCl5RmD99uHt
         HrFlWF/St5wbsPU9NC5w+qs1d5Tmbiv26pWFZQmk6SOG1xftIL9xGn26UKNZHYLoHgNe
         MHMw==
X-Gm-Message-State: APjAAAVptjD42QXa1XKRcMLwVCGWvZ1+wEI54qPd38d0DIqQtBW7Wvzr
        18QS7thPDBw8kOKYVQndQR1s+zpe
X-Google-Smtp-Source: APXvYqxSqijtVMf8K8AdF9inggiM0xSEcvh74cCLoqZG3TlFKrkpohBE52XwjAhu4PLhPqeU2j4wdg==
X-Received: by 2002:a1c:a7c6:: with SMTP id q189mr9765886wme.146.1560070617867;
        Sun, 09 Jun 2019 01:56:57 -0700 (PDT)
Received: from debian64.daheim (pD9E295B5.dip0.t-ipconnect.de. [217.226.149.181])
        by smtp.gmail.com with ESMTPSA id r6sm834230wrp.85.2019.06.09.01.56.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 01:56:57 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hZtdI-0002Yi-Ij
        for stable@vger.kernel.org; Sun, 09 Jun 2019 10:56:56 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     Stable <stable@vger.kernel.org>
Subject: add "mtd: spinand: macronix: Fix ECC Status Read" to 4.19
Date:   Sun, 09 Jun 2019 10:56:56 +0200
Message-ID: <3914666.MqBd33HHaW@debian64>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

please add this patch

Subject: mtd: spinand: macronix: Fix ECC Status Read
commit f4cb4d7b46f6409382fd981eec9556e1f3c1dc5d [0]
Author: Emil Lenngren <emil.lenngren@gmail.com>
Date:   Thu Dec 20 13:46:58 2018 +0100

to the stable release of 4.19.

Regards,
Christian

[0] <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f4cb4d7b46f6409382fd981eec9556e1f3c1dc5d>


