Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D883F3778
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 19:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfKGSpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 13:45:36 -0500
Received: from mail-qk1-f178.google.com ([209.85.222.178]:37273 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfKGSpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 13:45:36 -0500
Received: by mail-qk1-f178.google.com with SMTP id e187so2943248qkf.4
        for <stable@vger.kernel.org>; Thu, 07 Nov 2019 10:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=3YdIQEG3U8jQurl2x19OKOKrjxp4OCgzS5thF6ciVas=;
        b=LAMgJYihdZSiDAga8kcyBZKJXznBMmZ/3xlyXIJ3ROdRUwuWyuXhhm3TSlZKPq4VKU
         DW5jwgBWD0zYdEbdfWlaODNFArdx2rK/efdfLGM8UCg1c3EyOngoY36kdKqYAdVS9wFt
         LWkz7OTzlvzDsaj3ocRyUJQSW1Z51OlU+rM2lROF/CT+j7h0phkzEw2nY18m942I2k8U
         bLgqpdGH07AVEAZDC3NUH52TXwrn15Q3vXVymgIjwD921STzHuhpp4t++mD1objoiC0x
         hRctNvneozdiYnzIxl8zwFXR7J+DLobcMeFoRGTM2Zl2tiaQy2HaPWx+iYxAmv+7plaz
         S8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=3YdIQEG3U8jQurl2x19OKOKrjxp4OCgzS5thF6ciVas=;
        b=Q/9bHVWE5kXG6oQegw00qIOyHFyFTJVrwQG79rMzUwDXrlFvIOqtjTH3GclR0m2R6Y
         rFCEqtaRNpvaHCTND6lqnAMjvFFGdRRaC3iQWNxU7t4HOUH0n/WfBogrJJyCWyEUlWtn
         as+sbedFF2fXCZbQC0Yt3KkpJtru3x2h1eYPToqedh3+YVycY0jqKTI4YnIn5b8vfhIO
         2W9Jy2K/g7uM0t8hQ7BdLd8hvCUEPTTr5zpr7IN1mZ77BZUmuvEuSksR5uh1vhCecg6+
         TZzmWqYQnQ3kJ95YZTbxl7+Rp43X43yFi6tOFohE/i0bUsIYu8ZfYk2B2UmObgAUeX5O
         IF+A==
X-Gm-Message-State: APjAAAWao+g5qmOIUsbO7FWSEdc9W6yeooRRj4W/TyV6S3r1WbVErLnO
        SgOUIxaCEucmOmjojk0HzUTzLlBOvOn3fgBDizQzq7KJOjQ=
X-Google-Smtp-Source: APXvYqwIMS4XUvGrNwPYl033e9GAxMH3LYIUAEX1rQdv9PpEhY2T4J7Q5rLPwWKJojogOGyoTZ5LoaeFrFyg/GTZHR8=
X-Received: by 2002:a37:4912:: with SMTP id w18mr1524385qka.206.1573152333658;
 Thu, 07 Nov 2019 10:45:33 -0800 (PST)
MIME-Version: 1.0
From:   Brian Norris <briannorris@google.com>
Date:   Thu, 7 Nov 2019 10:45:22 -0800
Message-ID: <CA+ASDXM=wh7TqO55BSV-Z12iJz08uVonJScCUDCRA+_h8JGe0Q@mail.gmail.com>
Subject: [FOR STABLE] wireless: Skip directory when generating certificates
To:     stable <stable@vger.kernel.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello stable!

I'd like to see the following commit included in -stable trees:

commit 32b5a2c9950b9284000059d752f7afa164deb15e
Author: Maxim Mikityanskiy <maxtram95@gmail.com>
Date:   Tue May 7 20:28:15 2019 +0300

    wireless: Skip directory when generating certificates

As it is, CONFIG_CFG80211_EXTRA_REGDB_KEYDIR is broken between v4.15 and v5.2.

Thanks,
Brian

P.S. I've take the "Option 2" in
Documentation/process/stable-kernel-rules.rst. Let me know if I should
do differently.
