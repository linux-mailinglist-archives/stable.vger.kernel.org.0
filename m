Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8D02E3282
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 20:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgL0TGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 14:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgL0TGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 14:06:53 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE5CC061795
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 11:06:12 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id h205so19648688lfd.5
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 11:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y8fqVZQrGyzGR3fKvawdKPLLMQ3PRjIKQI/vPT2IhXs=;
        b=BrCa080DCUCABbSmkb2AHz+tkPAsSZAYYLf/SsKuVNh2efFAPi4uhdM2cJbVlHIwTB
         dasGzkvNdIeiXkmJMSS9Sw0wGRQtnX4Au/36WOd2zuYKUlXYhEMOcIx97LQhfOkIuLor
         Rilj++tTrqhrbKcixUhshxcMha96z36F4Y54o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y8fqVZQrGyzGR3fKvawdKPLLMQ3PRjIKQI/vPT2IhXs=;
        b=MukbveMaddzlTADvb8vvlJT0Ps0LGr5Pqee7S8dtmgMjyQHERx5FcNO+J5TLlwMi4K
         nCzrAGEnsTtwpZGJyT1bYSY9eIqctZwBLLpr1yxYnu+BzrXD2SFZsDDns0QLugL+npNM
         Ku3hv4Xb8RQuWufsrsLaCiUVrngQlOt7eWvb8dOovV9+2O5E8k0js0ggQPEvk+IkcyAT
         VnoIVBJjM5EVd+pf80KzBoCtzutexiH6xMG2fn60BXz5tXtHTIM9b4cFXlgmIhQExr6z
         hob49XGhY1BYfAV1F2shfUL1vm26If5oOq5fePM1ZQtWP0myIw/Mc3DjZQONFL2Y68iU
         fBCA==
X-Gm-Message-State: AOAM5329HmF/lOfIOnFMegroSBH5PlU8GrFZeY73AR3NSNIMuWCJ4sgB
        SvEIYUMSUi4JwQDq4Pr89wGwyw/7+zJS7Q==
X-Google-Smtp-Source: ABdhPJyiA2mrzCOJqy9BadqNMCMOejcMIzGxR1TzrqnlI2I7oQWddMcAdvaJO5CFCqA8rkm+c55+3A==
X-Received: by 2002:a2e:b555:: with SMTP id a21mr13544918ljn.356.1609095970921;
        Sun, 27 Dec 2020 11:06:10 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id 12sm5160414lfy.170.2020.12.27.11.06.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Dec 2020 11:06:09 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id x20so19582248lfe.12
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 11:06:09 -0800 (PST)
X-Received: by 2002:a2e:b4af:: with SMTP id q15mr19576111ljm.507.1609095968615;
 Sun, 27 Dec 2020 11:06:08 -0800 (PST)
MIME-Version: 1.0
References: <16089960203931@kroah.com> <5ab86253-7703-e892-52b7-e6a8af579822@iki.fi>
 <CAHk-=wgtU5+7jPuPtDEpwhTuUUkA3CBN=V92Jg0Ag0=3LhfKqA@mail.gmail.com> <b45f1065-2da9-08c0-26f2-e5b69e780bc6@iki.fi>
In-Reply-To: <b45f1065-2da9-08c0-26f2-e5b69e780bc6@iki.fi>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 27 Dec 2020 11:05:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgy6NQrTMwiEWpHUPvW-nfgX7XrBrsxQ6TkRy6NasSFQg@mail.gmail.com>
Message-ID: <CAHk-=wgy6NQrTMwiEWpHUPvW-nfgX7XrBrsxQ6TkRy6NasSFQg@mail.gmail.com>
Subject: Re: LXC broken with 5.10-stable?, ok with 5.9-stable (Re: Linux 5.10.3)
To:     Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: multipart/mixed; boundary="0000000000009e972905b776d991"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000009e972905b776d991
Content-Type: text/plain; charset="UTF-8"

On Sun, Dec 27, 2020 at 10:39 AM Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:
>
> 5.10.3 with patch compiles fine, but does not solve the issue.

Duh. adding the read_iter only fixes kernel_read(). For splice, it also needs a

        .splice_read = generic_file_splice_read,

in the file operations, something like this...

Does that get things working?

              Linus

--0000000000009e972905b776d991
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
Content-ID: <f_kj7i6lyu0>
X-Attachment-Id: f_kj7i6lyu0

IGZzL3Byb2NfbmFtZXNwYWNlLmMgfCA5ICsrKysrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5z
ZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9wcm9jX25hbWVzcGFj
ZS5jIGIvZnMvcHJvY19uYW1lc3BhY2UuYwppbmRleCBlNTlkNGJiM2E4OWUuLmVhZmI3NTc1NWZh
MyAxMDA2NDQKLS0tIGEvZnMvcHJvY19uYW1lc3BhY2UuYworKysgYi9mcy9wcm9jX25hbWVzcGFj
ZS5jCkBAIC0zMjAsNyArMzIwLDggQEAgc3RhdGljIGludCBtb3VudHN0YXRzX29wZW4oc3RydWN0
IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCiAKIGNvbnN0IHN0cnVjdCBmaWxlX29w
ZXJhdGlvbnMgcHJvY19tb3VudHNfb3BlcmF0aW9ucyA9IHsKIAkub3BlbgkJPSBtb3VudHNfb3Bl
biwKLQkucmVhZAkJPSBzZXFfcmVhZCwKKwkucmVhZF9pdGVyCT0gc2VxX3JlYWRfaXRlciwKKwku
c3BsaWNlX3JlYWQJPSBnZW5lcmljX2ZpbGVfc3BsaWNlX3JlYWQsCiAJLmxsc2VlawkJPSBzZXFf
bHNlZWssCiAJLnJlbGVhc2UJPSBtb3VudHNfcmVsZWFzZSwKIAkucG9sbAkJPSBtb3VudHNfcG9s
bCwKQEAgLTMyOCw3ICszMjksOCBAQCBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIHByb2Nf
bW91bnRzX29wZXJhdGlvbnMgPSB7CiAKIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgcHJv
Y19tb3VudGluZm9fb3BlcmF0aW9ucyA9IHsKIAkub3BlbgkJPSBtb3VudGluZm9fb3BlbiwKLQku
cmVhZAkJPSBzZXFfcmVhZCwKKwkucmVhZF9pdGVyCT0gc2VxX3JlYWRfaXRlciwKKwkuc3BsaWNl
X3JlYWQJPSBnZW5lcmljX2ZpbGVfc3BsaWNlX3JlYWQsCiAJLmxsc2VlawkJPSBzZXFfbHNlZWss
CiAJLnJlbGVhc2UJPSBtb3VudHNfcmVsZWFzZSwKIAkucG9sbAkJPSBtb3VudHNfcG9sbCwKQEAg
LTMzNiw3ICszMzgsOCBAQCBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIHByb2NfbW91bnRp
bmZvX29wZXJhdGlvbnMgPSB7CiAKIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgcHJvY19t
b3VudHN0YXRzX29wZXJhdGlvbnMgPSB7CiAJLm9wZW4JCT0gbW91bnRzdGF0c19vcGVuLAotCS5y
ZWFkCQk9IHNlcV9yZWFkLAorCS5yZWFkX2l0ZXIJPSBzZXFfcmVhZF9pdGVyLAorCS5zcGxpY2Vf
cmVhZAk9IGdlbmVyaWNfZmlsZV9zcGxpY2VfcmVhZCwKIAkubGxzZWVrCQk9IHNlcV9sc2VlaywK
IAkucmVsZWFzZQk9IG1vdW50c19yZWxlYXNlLAogfTsK
--0000000000009e972905b776d991--
