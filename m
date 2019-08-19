Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D57EF9230C
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 14:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfHSMIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 08:08:07 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45181 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfHSMIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 08:08:06 -0400
Received: by mail-lf1-f66.google.com with SMTP id a30so1199744lfk.12;
        Mon, 19 Aug 2019 05:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FjHZhaVZ8bW1jwSB163zu6P8fnlh+RcprWunL1wBQ1c=;
        b=Gkji77UwvlMoaD82M8Tkxq7u5atgOhMiRrvbSXAW/ctANbqwfsTil2IW1aUdIVsGNq
         f8AaA6O8pkydKpWnJSswVSqJTL2iMWJYbljS8O3ZmXMNjYg1cn2FdLHIsSKZTJxtx/+5
         HGf8JEOZaDQDQWCO2MqAQ/p26IGwpwUftMKLmEM85NSWVkWY62Os2EngceVVbeWu8Ir4
         aot76mAr603G5SXCTamEjy/BW3sLDo5M5PPdHCNC7dbXO+ZqU1ZepzzPMqJMvvISbTj7
         US6fNAA8KVLy3DYLe3CW5yEZzsbzsD+sVk2/QWXK6vr0KKzKMmMQK+XE83N6OOS6t/jO
         ShDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FjHZhaVZ8bW1jwSB163zu6P8fnlh+RcprWunL1wBQ1c=;
        b=RXlD7YcjlZPh3BdWuTukY29ZGxy9QBf9vCbrmRJmluM5/DAG6LpnLgxcr45yA0qvmo
         bZZrcv4Odge5jLm77saqCzqbTNo1NzH8mEacQLicxtkjaS+4HMh8P2PQK0lS143wrv3F
         cffAyxZmoD8B1IRRgQhtN+cfVnOmY3kbkO2UTgAmS3jwjKGO04jQzylqEf7kvgo9e+7D
         F2zhY3xV5Y+EGUw8KOdkWbVoJGZzQRD9CWrQwe0yHgApBvO1yKqNMmef9J2VrXgKzL6B
         zQeiYYwFvZc1MaPTaAqAZnDee4n2o7BOdqYWT8x9StFjueV5BQe1aYpMckg7ZXONIJz2
         +wiw==
X-Gm-Message-State: APjAAAXjWrC8KXafmiUB8zNgfH43KKmxJV4Zo9MCVQQA3E7uXqjYEuP6
        YMrdRnSnFDJp54vwgLog0uErS+9bd88IgWyIh6A=
X-Google-Smtp-Source: APXvYqx0OfAJZnXoLWjyzqdkZsMmr64aXEWROOMp/3ttQe3fmPjqCXqY+i//CRQuHiw+X86T1YcMPzldnXn4Djm0P9k=
X-Received: by 2002:ac2:46ea:: with SMTP id q10mr11746594lfo.118.1566216484462;
 Mon, 19 Aug 2019 05:08:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190806213749.20689-1-sashal@kernel.org> <20190806213749.20689-4-sashal@kernel.org>
In-Reply-To: <20190806213749.20689-4-sashal@kernel.org>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Mon, 19 Aug 2019 14:07:53 +0200
Message-ID: <CA+res+RryNtrD3pydEn1G9HWnkDS780AaBEQQPNRqkx8rSzGJA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.4 04/14] perf header: Fix divide by zero error
 if f_header.attr_size==0
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> =E4=BA=8E2019=E5=B9=B48=E6=9C=886=E6=97=A5=
=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=8811:39=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Vince Weaver <vincent.weaver@maine.edu>
>
> [ Upstream commit 7622236ceb167aa3857395f9bdaf871442aa467e ]
>
> So I have been having lots of trouble with hand-crafted perf.data files
> causing segfaults and the like, so I have started fuzzing the perf tool.
>
> First issue found:
>
> If f_header.attr_size is 0 in the perf.data file, then perf will crash
> with a divide-by-zero error.
>
> Committer note:
>
> Added a pr_err() to tell the user why the command failed.
>
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/alpine.DEB.2.21.1907231100440.14532@macboo=
k-air
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/perf/util/header.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
Hi all,

This on cause build failure when I rebased to 4.14.140-rc1 in stable-rc tre=
e.

    util/header.c: In function 'perf_session__read_header':
    util/header.c:2907:10: error: 'data' undeclared (first use in this
function); did you mean 'dots'?
              data->file.path);
  Should be fixed by:
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2904,7 +2904,7 @@ int perf_session__read_header(struct
perf_session *session)
        if (f_header.attr_size =3D=3D 0) {
                pr_err("ERROR: The %s file's attr size field is 0
which is unexpected.\n"
                       "Was the 'perf record' command properly terminated?\=
n",
-                      data->file.path);
+                      file->path);
                return -EINVAL;

Regards,
Jack Wang

> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 304f5d7101436..0102dd46fb6da 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -2591,6 +2591,13 @@ int perf_session__read_header(struct perf_session =
*session)
>                            file->path);
>         }
>
> +       if (f_header.attr_size =3D=3D 0) {
> +               pr_err("ERROR: The %s file's attr size field is 0 which i=
s unexpected.\n"
> +                      "Was the 'perf record' command properly terminated=
?\n",
> +                      data->file.path);
> +               return -EINVAL;
> +       }
> +
>         nr_attrs =3D f_header.attrs.size / f_header.attr_size;
>         lseek(fd, f_header.attrs.offset, SEEK_SET);
>
> --
> 2.20.1
>
