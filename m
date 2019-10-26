Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB75E5F42
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 21:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfJZTll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 15:41:41 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40865 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfJZTll (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Oct 2019 15:41:41 -0400
Received: by mail-lj1-f194.google.com with SMTP id u22so6999269lji.7
        for <stable@vger.kernel.org>; Sat, 26 Oct 2019 12:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=lEi6jMgH3eOkIIQxg3KFN1FawC0di4EyrdH/s6XHtF0=;
        b=AkN6ZA47GPlMMM+izkzR1Vk1jO7IIH9q0CCyKFSHEk8tTV1wBOwTWuWma9ZE3lcpqK
         cgE+G0sRTDrTY4L1gZemH7Jgbhvtedz2hWzj0CX/cqnv/5NTWgYqYJKJ0LQ9sy/Txujs
         BTrUCRS9w9jCUEZPzokEFQ7HhhkpErj1n3BDaNbZvY8qU2IXbv2zr/OckVkcmRXpYsTj
         Zn+XKtk1YXPwQxrEXgXstiBWhwiRQy5LptXWkkLuiEgJvgZYU9Ok5oKX7kvZh4ZOsDmO
         6OSQd86eNuUdpWbZDsGGH9lJ5FS73MQC0rtDeORoRlzTYEITowjYdESB66j0pUnlj6Dx
         +f+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lEi6jMgH3eOkIIQxg3KFN1FawC0di4EyrdH/s6XHtF0=;
        b=TGN7uWahI7EL6cY/VqSLDFK2eppU4kacHRJsLhv+Gpac1SXa0cwBpQTcR9BiyPQtgS
         Bs5KeQxDYCE0KBlWEzlDxYsnw8pvO7Fjzpj/d4uJrLPaHtTppbO3kiIpX75YsClleXDY
         ozsT/My231JQb8qOWMZ20B/bDL4tjvNm8WlTNqZyZI0n5vSGZXHZ4ahtdfsGaZRWLEr4
         kbHONXQ8JMRJBn1NrUKfBccioIFysJ0HUxq0ZTeQSn+dCy1HxjczLOKahdK42D8pIPDM
         k+PyBrO0hSsNQxAcUotfHCF45pQWE3wBDUQZ43A/CqpF9jsPTwqiGfACUcnHYA+v2ABQ
         E+lQ==
X-Gm-Message-State: APjAAAX+GJzb9+WNDeQYnXdU69zBHcJsXxUuQp70B6TBZGnfg6PkAh0s
        QNIgdMP57mzuykSarc4i5ziBND/tnu+cDlmJrtA1prut
X-Google-Smtp-Source: APXvYqwqHhiPHQgJE1SsiEVBmUgewLG5CSeziKHwlcmB6rsD74+b/AESdlunLLTPgoboAF6yBv/oQEo0NWxnAoFIZ4o=
X-Received: by 2002:a2e:350f:: with SMTP id z15mr6993306ljz.185.1572118898122;
 Sat, 26 Oct 2019 12:41:38 -0700 (PDT)
MIME-Version: 1.0
From:   Vincent Fortier <th0ma7@gmail.com>
Date:   Sat, 26 Oct 2019 15:41:27 -0400
Message-ID: <CALAySuL6D7_LAK6tpzhBg07664NYFGfhe-A5G0H2vNWvdP=uqA@mail.gmail.com>
Subject: Request for backporting to 4.4 & 4.9: xenbus: Avoid deadlock during
 suspend due to open transactions
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

I just found out that there may be a fix for our live-migration issues
that we have been plagued with for quite a while.  The fix sits under
5.2 kernel at:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.2.21&id=d10e0cc113c9e1b64b5c6e3db37b5c839794f3df

I believe this is material for the 4.4 & 4.9 stable trees as we've
been hitting this issue under ubuntu 4.4 kernels.

Thnx in advance!

- vin
