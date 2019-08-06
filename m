Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C97EF834FF
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 17:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731378AbfHFPTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 11:19:37 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:36670 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728156AbfHFPTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 11:19:37 -0400
Received: by mail-oi1-f169.google.com with SMTP id c15so11723197oic.3
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 08:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=5rQbCxotG8j0awemigJ/cJzhrv15WBVwcFj93s0RfY0=;
        b=AdjSKOzm6Z6omu2+C3QRNXbzBXSvWJt9T9gE2kTQe8UYNxN8cxk9YRscMCKZ74cErC
         j6NNLujq7Vp0XGoyKMYKC8AilYMpq8N42qpZ6fxzciMs0CUHHjFXGZSWyqnk668qK5br
         kEsSzeCalGOe271XhBj1eWPyYvIiJcg/HZp3sWbKi6nqACMYnAU+xinCM/ZsAb9kvC8B
         4WnO0TPsv3QZPmGZhWv9AHhoeLV9aeAJf8qvx/dMSIeB7N/oYLjWgZdL3CEBDJSc4Tcb
         hfiYR+bVyaVD2i9SaPTfo2+uhHRPrlTSlenSGW3xCeyPUvAycyG6VJVSEjgnq8MN+4ix
         XE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=5rQbCxotG8j0awemigJ/cJzhrv15WBVwcFj93s0RfY0=;
        b=G8XC4yp8AltKtyMC8sBExrKxl/t/ttLZrxneeRXN0gjJqCMovOtQWOxDEqccaQZaDC
         h1lKmU5yZ3WlCHnRN6uLE71Dm251zfiyKrrmn32XVyWAmPWbs9CP9a/yKRh4FfQC9voG
         D41nBsEmGTGo1lasQjqGW9WtNve3brut5cChwhDY7gYhzQmDHF9mT5fboMhGdOCLW7Ep
         Rbiwg6+8BsDnbhWYz9Rcm9QnXTQIC5IIYz1sj5kAinmWYsieVYPiryDWF+2vSj1XO1Cc
         41sQl/4Wx+ZzkCzpvD6eJuRZPqEx4sawEt80bemRaV3kXxwiGhUvGeKIiwWITZ25gupH
         1X3Q==
X-Gm-Message-State: APjAAAVlKQw4W/MKqqYbDUaD/X1lYk8Q2dW8rneyuihR88z56qYGuUdm
        xf+RO6tZ/jJuJlz0q8CrrTXA0a5IXkc1wz8gVt7fHuhw
X-Google-Smtp-Source: APXvYqw6HCFftGBzTIWlohCDQpQk2MsmdxYJU+ZRoRTJtqP4OEJkrQ/NAAd1sKwe/jlVc9bXmM1YQh0Q0YCpWgZznz8=
X-Received: by 2002:a02:1a86:: with SMTP id 128mr4746675jai.95.1565104775627;
 Tue, 06 Aug 2019 08:19:35 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Ford <aford173@gmail.com>
Date:   Tue, 6 Aug 2019 10:19:24 -0500
Message-ID: <CAHCN7x+Mbu=g1CgV2pbaojiwbej49aAmc5ufj8eacd-mcezEKQ@mail.gmail.com>
Subject: ARM: dts: logicpd-som-lv: Fix Audio Mute
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply 95e59fc3c3fa3187a07a75f40b21637deb4bd12d ("ARM: dts:
logicpd-som-lv: Fix Audio Mute") to 4.9 branch.

Thank you,

adam
