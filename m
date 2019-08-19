Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9CD92581
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 15:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfHSNtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 09:49:51 -0400
Received: from mail-lj1-f171.google.com ([209.85.208.171]:34630 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbfHSNtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 09:49:51 -0400
Received: by mail-lj1-f171.google.com with SMTP id x18so1841272ljh.1
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 06:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6rNAUX1Lx7VawQTYiGRrbQTvk3uhVbF9IkV8+irTwHE=;
        b=NWx5hVUWr9XWVj+k1ED6cxu/DNlV+dgV68HIrkMJBaf4CETPqv962hh8rFf135anfu
         d8DKr8e7Oai0coPb9xJysfAb8q8gNp0lOZ8l6/JNhnZG3ASr1X7jRiQ8EcGTBnEVlr5Z
         qNGMKYJJk9dx8fY1Ko0i2bC9ksJido1yulZMa0KgTOtV3PF35y8psEQYm9BfTD68EDW8
         mhUyd86DYibYxwtvliuBBpZ3XasrTdOiXyRoQGWT7FQ1pRkjCwIwDOi8xtq+R2OO5YA4
         NPwZbcS0fmD1FLUCjiw69RoMLjEDb64pto2Z+7soCFXhSdJzCxnuB2b9jgCA+HxrExjn
         nu8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6rNAUX1Lx7VawQTYiGRrbQTvk3uhVbF9IkV8+irTwHE=;
        b=OAsoPdyEfSBBkKVAZB4ncGSQqY5NW4pKTpxZkpURgGWPv7LJj9YqspHowxHP6xsc6G
         FgKr72XGNyK8UjsVmkt/B2KjMS33/mkza9al9lyuzs6I7YrznRQ9xBIYSydta9WnDJIp
         wcnMkD4fJ3hMZ5z2dr8bRK2m/RUxW2nC7xHbS8457289lC9HAa8yxdmqa4jwS5GBaAcw
         SZuOHKnkNdvnxRoWySVBGdk9KkCsyV1VhAWkhlkmgpyukiE0HF9u5FK5H9HG5KfsizZl
         /ugvqfwo0cJcrzm+WQzUT1j0GTgZd8VvmygwUzLT/fXC6npq7MmMNsYD+/Z8zTSjpuZi
         3CWQ==
X-Gm-Message-State: APjAAAWKi2OCF0ICubDZXjmGI61+UEdNKvD2u7lmvRis/OQJyFvCluGJ
        xjFeEMuUrTrzUwgrBVaL2fRdRluzTyf0zk/SYPY=
X-Google-Smtp-Source: APXvYqwxg/rJuRSYjIF9jr+0cQT0kcKZ+M2UnjUtWQJkZpoSSdt8J6QSr4DvSMQCM9GfTRI0tSa8slbmYmd4FrAuizE=
X-Received: by 2002:a2e:995a:: with SMTP id r26mr5552116ljj.198.1566222589601;
 Mon, 19 Aug 2019 06:49:49 -0700 (PDT)
MIME-Version: 1.0
References: <7eb8b107-1fa8-9619-9608-e064c45a2c8d@roeck-us.net>
In-Reply-To: <7eb8b107-1fa8-9619-9608-e064c45a2c8d@roeck-us.net>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Mon, 19 Aug 2019 15:49:38 +0200
Message-ID: <CA+res+Q=TMpJLTHMgWLH+DMyUp0ozFVCmtSSENukRYLGu=nroA@mail.gmail.com>
Subject: Re: perf build failures in {v4.4,v4.9,v4.14}.y.queue
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> =E4=BA=8E2019=E5=B9=B48=E6=9C=8819=E6=97=
=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=883:36=E5=86=99=E9=81=93=EF=BC=9A
>
> util/header.c: In function =E2=80=98perf_session__read_header=E2=80=99:
> util/header.c:2860:10: error: =E2=80=98data=E2=80=99 undeclared
>
> Culprit is "perf header: Fix divide by zero error if f_header.attr_size=
=3D=3D0".
>
> Fix might be to replace "data->file.path" with "file->path" in the affect=
ed
> branches.
>
> Guenter
I had same error on 4.14.140-rc1, and yes, replace data->file.path
with file->path works.

Thanks & Regards
Jack Wang
