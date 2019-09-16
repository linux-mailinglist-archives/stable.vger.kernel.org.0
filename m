Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E919B3DE2
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 17:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731417AbfIPPp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 11:45:26 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:41488 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731218AbfIPPp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 11:45:26 -0400
Received: by mail-ot1-f49.google.com with SMTP id g13so248233otp.8
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 08:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lonelycoder.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=jj40J4zrPJPGp1E1oyBbDEJtkpqG/+ZlgHSSaHOnUcs=;
        b=ZRcv5plL36du0l9jWF9n4bgBjikMgPdUXTs/5AYzQFtY3lcJCDS3k3sWdSX587V4RZ
         oU0xvnbQuEjrhACgPoK1FB22gMs/PUa4HEzn1VlT+ZxleQuABNLkIo6ENraztYzNKhUB
         tnIb/d0RkJmd0bJ/pn8OEclYUVuBitos1umLreX+h8QHOHS3esGiP92k9YTnhuBIDeYm
         S/1rorhVYh/b264m93M5DZbsEJNYiZiWUfX8QFZmNiulZbuvuv/c7oRH5pqHVwssnZA8
         dnLmlYqgXmXRFEMbhnUhqFpkZc5PeECEi5tC9uHw/zpzbH1vKNtdAJhrNZwplho3ee9j
         X+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jj40J4zrPJPGp1E1oyBbDEJtkpqG/+ZlgHSSaHOnUcs=;
        b=JbiZvBxnY+0nZnqYDfNbYhVwsECQMQgBCcU9b9T60SvZGY6gf3eZFLKTnp3053bwWb
         yri6iwxZKDAeSmfR7bHC+6iFeUqxxK9IY7zPfDqNj4TANNStUhMcJ8KsojTYJZZTLNzq
         kDb+TNYrEYhO6uY9U2coQB6yUIiNd0kr8ba5gnOrTxeEdFwsd+Plv+tt/QJdTZKmUuh9
         wzsio12m7auTMqkCbKWx8ziiBGjEgFCaee9O8zvvbDsWNLVO7Oji7oT5IoedcADMS10/
         LSsFXa9BhRFzEBpLtH4G0hQ1SwXRX/6qd+RGcTThRogXgrp2Ho8G8A/3Zy0hcEIV9b43
         kfhA==
X-Gm-Message-State: APjAAAVL9IcnQ5VLYZevLgKhOLOq+50TXtVfWX4RYY74j5KAtHeCvYah
        WnWWiUgkBoPQPy0uM+wjyT8AcP/vCWCdaBaU7vZCY3xIJjk=
X-Google-Smtp-Source: APXvYqxz1tbSQW52cXJb4mMmBzdJ32xMa/23lLY1zfKElcieEgZSzG/XAXgopeH2Mw+vqcZrJoJ6otIRIgZNNpTRJXk=
X-Received: by 2002:a9d:2901:: with SMTP id d1mr9189316otb.285.1568648725605;
 Mon, 16 Sep 2019 08:45:25 -0700 (PDT)
MIME-Version: 1.0
From:   Andreas Smas <andreas@lonelycoder.com>
Date:   Mon, 16 Sep 2019 08:45:14 -0700
Message-ID: <CAObFT-TGNVkmm5sgJ4AQfuo6qDtB6y7zAu7L6uyMx+veLjSZYg@mail.gmail.com>
Subject: Please include e16c2983fba0 in 4.19.y and 5.2.y
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

The commit

  e16c2983fba0: x86/purgatory: Change compiler flags from
-mcmodel=kernel to -mcmodel=large to fix kexec relocation errors

fixes a regression introduced by:

  b059f801a937 x86/purgatory: Use CFLAGS_REMOVE rather than reset KBUILD_CFLAGS

which has gone into 4.19.y and 5.2.y

Thanks,
Andreas
