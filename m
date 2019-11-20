Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD6D1030E0
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 01:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfKTAsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 19:48:55 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34530 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfKTAsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 19:48:54 -0500
Received: by mail-qk1-f196.google.com with SMTP id 205so19788286qkk.1
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 16:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S9FrsG3KrrHMDR9Uv+iYjJ7joPiA0o5ZEwNXiJXSdBM=;
        b=U83j6zSWbqxvyqZJDIIrSYWbQhKZScO7YCBVOTNKlwaKrc106A8OZuZ2+8llmRlD7B
         VVlKTt8hXfJd/foy8UU/et3Cs3iqZrIQ5Uk3r04KdDOBhgJCvc3m7AcDizwT8REELCRK
         2rU1lfsTjOzgwo+ub9di0sLdOPbZH+GnZLYmzAI398lwaP8ycC+qX2tmVOTW4pb3kGJw
         hedzXEKfW6p+LU+usV9xuVg9jfPTzob8aKHtRSlMv8VX2NjxyKIIaYpaGQyUQlxTFI0a
         hMKObZnMdLL+sLmRhtiXKffJEoClwhRMemRYSPxIGMzSHmgM4GGaX/Och9mVjxkqExqc
         ZViw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S9FrsG3KrrHMDR9Uv+iYjJ7joPiA0o5ZEwNXiJXSdBM=;
        b=Uw5q4qrsylkRAbcaHpprxqEJFBVIml3KkOxG7qKBBG7Ro6GQ0du+BtG/iBICF/CLMh
         76WChci1s4bwF4rt7xvqrOHNh5+ZYPjXwnmNSs/JAu/0YkzLgmbNJHD9tOpRuIlwM2zd
         fjH7xVhus9BtYKNDZ+RIdAfi9oONiSQPcGaSF8SHX2smVQRLbKgRTYPY17l7dew87Eb1
         6mNCHwfoA24Jy7EgUU1wnk4LK/69t5+KNvZeKMNuE28Yji7OhrUi50A4OqgNAJRBoBIm
         VqZ1fgNwDVIjvyCgSXVkk32Mv07B6VbAT/nyZyaoGaOA5hN88WSbXtsUd7ZbpRJ3/8mV
         JYsg==
X-Gm-Message-State: APjAAAXrzFmeMuM2aFKw0ZUOhZYyIrr1EWUrftdDYS2Xs2aiBvv/1USC
        2s8bpf4Ha36bzJZq7ibLWzQ6GWFdHJ0T6fEbHW/E++DVcnoPUg==
X-Google-Smtp-Source: APXvYqwOJUy/dcjBnWswHPZjBux5iGNlWu5mvZYlRjgDNBgEozECw6k43zbeHRSpM9Ihz+sHZ6tz4LoGs1WlsBCPfZM=
X-Received: by 2002:a37:a5cf:: with SMTP id o198mr61813qke.493.1574210932792;
 Tue, 19 Nov 2019 16:48:52 -0800 (PST)
MIME-Version: 1.0
References: <20191119101718.38976-1-mst@redhat.com>
In-Reply-To: <20191119101718.38976-1-mst@redhat.com>
From:   Khazhismel Kumykov <khazhy@google.com>
Date:   Tue, 19 Nov 2019 16:48:41 -0800
Message-ID: <CACGdZYLzo1LUjJuKgZrqaq8FJGVp+QUPs2pjCEnAHyMeTfuKfQ@mail.gmail.com>
Subject: Re: [PATCH] virtio_balloon: fix shrinker scan number of pages
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000803cd90597bc8ba9"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000803cd90597bc8ba9
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 19, 2019 at 2:17 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> virtio_balloon_shrinker_scan should return number of system pages freed,
> but because it's calling functions that deal with balloon pages, it gets
> confused and sometimes returns the number of balloon pages.
>
> It does not matter practically as the exact number isn't
> used, but it seems better to be consistent in case someone
> starts using this API.
>
> Further, if we ever tried to iteratively leak pages as
> virtio_balloon_shrinker_scan tries to do, we'd run into issues - this is
> because freed_pages was accumulating total freed pages, but was also
> subtracted on each iteration from pages_to_free, which can result in
> either leaking less memory than we were supposed to free, or or more if
> pages_to_free underruns.
>
> On a system with 4K pages we are lucky that we are never asked to leak
> more than 128 pages while we can leak up to 256 at a time,
> but it looks like a real issue for systems with page size != 4K.
>
> Cc: stable@vger.kernel.org
> Fixes: 71994620bb25 ("virtio_balloon: replace oom notifier with shrinker")
> Reported-by: Khazhismel Kumykov <khazhy@google.com>
> Reviewed-by: Wei Wang <wei.w.wang@intel.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/virtio/virtio_balloon.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 226fbb995fb0..7cee05cdf3fb 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -772,6 +772,13 @@ static unsigned long shrink_free_pages(struct virtio_balloon *vb,
>         return blocks_freed << VIRTIO_BALLOON_FREE_PAGE_ORDER;
>  }
>
> +static unsigned long leak_balloon_pages(struct virtio_balloon *vb,
> +                                          unsigned long pages_to_free)
> +{
> +       return leak_balloon(vb, pages_to_free * VIRTIO_BALLOON_PAGES_PER_PAGE) /
> +               VIRTIO_BALLOON_PAGES_PER_PAGE;
> +}
> +
>  static unsigned long shrink_balloon_pages(struct virtio_balloon *vb,
>                                           unsigned long pages_to_free)
>  {
> @@ -782,11 +789,9 @@ static unsigned long shrink_balloon_pages(struct virtio_balloon *vb,
>          * VIRTIO_BALLOON_ARRAY_PFNS_MAX balloon pages, so we call it
>          * multiple times to deflate pages till reaching pages_to_free.
>          */
> -       while (vb->num_pages && pages_to_free) {
> -               pages_freed += leak_balloon(vb, pages_to_free) /
> -                                       VIRTIO_BALLOON_PAGES_PER_PAGE;
> -               pages_to_free -= pages_freed;
> -       }
> +       while (vb->num_pages && pages_freed < pages_to_free)
> +               pages_freed += leak_balloon_pages(vb, pages_to_free);

pages_to_free - pages_freed ?

> +
>         update_balloon_size(vb);
>
>         return pages_freed;
> @@ -799,7 +804,7 @@ static unsigned long virtio_balloon_shrinker_scan(struct shrinker *shrinker,
>         struct virtio_balloon *vb = container_of(shrinker,
>                                         struct virtio_balloon, shrinker);
>
> -       pages_to_free = sc->nr_to_scan * VIRTIO_BALLOON_PAGES_PER_PAGE;
> +       pages_to_free = sc->nr_to_scan;
>
>         if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
>                 pages_freed = shrink_free_pages(vb, pages_to_free);
> --
> MST
>

--000000000000803cd90597bc8ba9
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIS5wYJKoZIhvcNAQcCoIIS2DCCEtQCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghBNMIIEXDCCA0SgAwIBAgIOSBtqDm4P/739RPqw/wcwDQYJKoZIhvcNAQELBQAwZDELMAkGA1UE
BhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExOjA4BgNVBAMTMUdsb2JhbFNpZ24gUGVy
c29uYWxTaWduIFBhcnRuZXJzIENBIC0gU0hBMjU2IC0gRzIwHhcNMTYwNjE1MDAwMDAwWhcNMjEw
NjE1MDAwMDAwWjBMMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEiMCAG
A1UEAxMZR2xvYmFsU2lnbiBIViBTL01JTUUgQ0EgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBALR23lKtjlZW/17kthzYcMHHKFgywfc4vLIjfq42NmMWbXkNUabIgS8KX4PnIFsTlD6F
GO2fqnsTygvYPFBSMX4OCFtJXoikP2CQlEvO7WooyE94tqmqD+w0YtyP2IB5j4KvOIeNv1Gbnnes
BIUWLFxs1ERvYDhmk+OrvW7Vd8ZfpRJj71Rb+QQsUpkyTySaqALXnyztTDp1L5d1bABJN/bJbEU3
Hf5FLrANmognIu+Npty6GrA6p3yKELzTsilOFmYNWg7L838NS2JbFOndl+ce89gM36CW7vyhszi6
6LqqzJL8MsmkP53GGhf11YMP9EkmawYouMDP/PwQYhIiUO0CAwEAAaOCASIwggEeMA4GA1UdDwEB
/wQEAwIBBjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwEgYDVR0TAQH/BAgwBgEB/wIB
ADAdBgNVHQ4EFgQUyzgSsMeZwHiSjLMhleb0JmLA4D8wHwYDVR0jBBgwFoAUJiSSix/TRK+xsBtt
r+500ox4AAMwSwYDVR0fBEQwQjBAoD6gPIY6aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9ncy9n
c3BlcnNvbmFsc2lnbnB0bnJzc2hhMmcyLmNybDBMBgNVHSAERTBDMEEGCSsGAQQBoDIBKDA0MDIG
CCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzANBgkqhkiG
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
BQUHMAKGNGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzaHZzbWltZWNhMS5j
cnQwHQYDVR0OBBYEFJ2Vb0jiXUWlD5ibz23a558NzWOgMB8GA1UdIwQYMBaAFMs4ErDHmcB4koyz
IZXm9CZiwOA/MEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8v
d3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMDsGA1UdHwQ0MDIwMKAuoCyGKmh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NodnNtaW1lY2ExLmNybDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMA0GCSqGSIb3DQEBCwUAA4IBAQCk2Fht/QkHdD9YQlQ/
/BoVlZzl+wg2oB8mPQEGNN49NfSL/ERAGoituF3/Zv+xv6owWk2Xp+sTA69OuAt2wZ4O0pXm2NNb
yE0QS1h/jH61IgJY4dU65qPcUYmkEdBDRX3XzR1wmnDc3yelHxlYerMuJFmSM5g4dIjbdpOlHTGh
jnWrjPPoGaT9nEbPfTxkahJTybnCIMuQbt8nl2QdV64GhBMCQWbIW1xY6Uv0FZcadQhF1vzhd/OH
qGkK98y1Dz/54GBO4A8jOSeDFuh+l2iygTcH16xKfB0XvhoUGdrru24FTEY7p4VTKkw+eJbUvdod
PlESVftk7+JISQWxBEYKMYICXjCCAloCAQEwXDBMMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xv
YmFsU2lnbiBudi1zYTEiMCAGA1UEAxMZR2xvYmFsU2lnbiBIViBTL01JTUUgQ0EgMQIMROfpbOE2
LmBNcT9PMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCByQUYmwNENCDA9fjx5oN+5
aktk8tK+plKtIcK/Dz1YpDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
Fw0xOTExMjAwMDQ4NTNaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQB
FjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzALBglg
hkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAG10f+sjBRj2RgVXU5Si3knz+ZiZBv7Yy2dvWBP9X
qIqC1EPb4oTulnHLZ7tl2Xu+nPn9lt3MXez8QziDihWOJyVCbvnmhFEqQT5KLWuABDLw8aJuLk+T
LlMWyhQLIRykQae9YzVeIrjOLIIkz9e+pG0GMSJqfxOKw4aZZTL6xLAEaRiYtuClqH9JebatMfSC
YZXL9//WPHiA9NPSe6twJzpdhvsBPN6ImEJvvpSl40T3yIWzOI6EuittrwyFPNVTfcsPNn8nI3/O
aFN7gIUU60Ro2o1svOOucqsyiio2tUfI69ol8Q2R+wsQgO0z/8bI5CyAx7r7clLgPN8ExJUa7g==
--000000000000803cd90597bc8ba9--
