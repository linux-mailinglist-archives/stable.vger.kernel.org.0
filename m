Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2B41AB12A
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 21:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411739AbgDOTHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 15:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1416853AbgDOSsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 14:48:40 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04424C061A0C;
        Wed, 15 Apr 2020 11:48:40 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id m13so917682otf.6;
        Wed, 15 Apr 2020 11:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pN11y4ZdGS2rg3j3opehc48No1ahmjWL1qeQQLOIN1Q=;
        b=Pg8N+hOBAmKceohWXn6EgeZxHLL8HX/ueT/MFBpSdvyQKXpYVe1x9LWr1rgkkLcKxF
         WAp/UiHYMZvUrKi3U/iUFQe7xIIkmrtDeaOj0WOBAGYmPy78ctyErXQ3C8ES0ZHfaoCJ
         eK7BMzMExFIidq8OYXDc2xiWyRU9yoRbrihqWpvevz8AYGFxUWxxZsbhOZwrdjOGlaQW
         7glGdDtZzQ3Ux6nflcc9L6wxEy3Ih6pxF96JkEseyxAfjolLsEym3m9YhLBMZzdnTzMW
         PJgrqUW3aIXx7AWxmxzrccD2phhejd2LZTZgzoqQzyX8WdaBGgxo8XoAbgyXTvnlfGFq
         66Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pN11y4ZdGS2rg3j3opehc48No1ahmjWL1qeQQLOIN1Q=;
        b=dIVuadlM3x6Qil2Y7Rf+hx1RS+HobTDQh5uzXDobIHdxPCQ84A6Xemcw4YSIsgNC8F
         yO7h3gegJnxUM/69hwHsOXanewgN3FZPWDeXfZ67Xi6v/M5fqw0tipEQ/U8+bsuWUsQ6
         /2193+5uqI6HhLpzbGdS9rTVK6lvNmUuPmfzj4bmbp8nrJDEeXrWCrWUCxlDLTyxhEHv
         vx7YI7Xz0mC4NPIW/71aipEQ2OyT3fPtl2whjDRlKHbn5CIubzNQr64hWtkW485aGm2t
         xZAxq0ywD9bYouI2sbr9vyrNFTdQEZgacLmDFemGEnDmA2asd9Uxp6DNTUL1IafF24gG
         Aoqg==
X-Gm-Message-State: AGi0PuZyKX1/uBj0QIaUrYQh5xAxKuteFO7WwRdpUhICet4ADkKbNvWS
        7SWVCSljMykYHgXJWt7+ln9rXpBTbddkf8pvK6MTdhd7
X-Google-Smtp-Source: APiQypL6qbcCQYIKcDc1OEn2YiQ6QGpnKqdVtbn/ICRL5+YY2B7SV1sFV34he2dQuuGxYSgmj6+k8LNxG6VBDQfbCBg=
X-Received: by 2002:a05:6830:215a:: with SMTP id r26mr22571197otd.118.1586976519067;
 Wed, 15 Apr 2020 11:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200408145837.21961-1-jason.gerecke@wacom.com>
In-Reply-To: <20200408145837.21961-1-jason.gerecke@wacom.com>
From:   Jason Gerecke <killertofu@gmail.com>
Date:   Wed, 15 Apr 2020 11:48:27 -0700
Message-ID: <CANRwn3QH3a=BOWWu6H7o2S3o3FCTWd6J_NC4xJ-WnQTZ-Pp7Hg@mail.gmail.com>
Subject: Re: [PATCH] Revert "HID: wacom: generic: read the number of expected
 touches on a per collection basis"
To:     Linux Input <linux-input@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jikos@kernel.org>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "# v3.17+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bumping since it seems to have been lost between the cracks.

Jason
---
Now instead of four in the eights place /
you=E2=80=99ve got three, =E2=80=98Cause you added one  /
(That is to say, eight) to the two,     /
But you can=E2=80=99t take seven from three,    /
So you look at the sixty-fours....


On Wed, Apr 8, 2020 at 7:59 AM Gerecke, Jason <killertofu@gmail.com> wrote:
>
> From: Jason Gerecke <killertofu@gmail.com>
>
> This reverts commit 15893fa40109f5e7c67eeb8da62267d0fdf0be9d.
>
> The referenced commit broke pen and touch input for a variety of devices
> such as the Cintiq Pro 32. Affected devices may appear to work normally
> for a short amount of time, but eventually loose track of actual touch
> state and can leave touch arbitration enabled which prevents the pen
> from working. The commit is not itself required for any currently-availab=
le
> Bluetooth device, and so we revert it to correct the behavior of broken
> devices.
>
> This breakage occurs due to a mismatch between the order of collections
> and the order of usages on some devices. This commit tries to read the
> contact count before processing events, but will fail if the contact
> count does not occur prior to the first logical finger collection. This
> is the case for devices like the Cintiq Pro 32 which place the contact
> count at the very end of the report.
>
> Without the contact count set, touches will only be partially processed.
> The `wacom_wac_finger_slot` function will not open any slots since the
> number of contacts seen is greater than the expectation of 0, but we will
> still end up calling `input_mt_sync_frame` for each finger anyway. This
> can cause problems for userspace separate from the issue currently taking
> place in the kernel. Only once all of the individual finger collections
> have been processed do we finally get to the enclosing collection which
> contains the contact count. The value ends up being used for the *next*
> report, however.
>
> This delayed use of the contact count can cause the driver to loose track
> of the actual touch state and believe that there are contacts down when
> there aren't. This leaves touch arbitration enabled and prevents the pen
> from working. It can also cause userspace to incorrectly treat single-
> finger input as gestures.
>
> Link: https://github.com/linuxwacom/input-wacom/issues/146
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
> Fixes: 15893fa40109 ("HID: wacom: generic: read the number of expected to=
uches on a per collection basis")
> Cc: stable@vger.kernel.org # 5.3+
> ---
>  drivers/hid/wacom_wac.c | 79 +++++++++--------------------------------
>  1 file changed, 16 insertions(+), 63 deletions(-)
>
> diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
> index d99a9d407671..96d00eba99c0 100644
> --- a/drivers/hid/wacom_wac.c
> +++ b/drivers/hid/wacom_wac.c
> @@ -2637,9 +2637,25 @@ static void wacom_wac_finger_pre_report(struct hid=
_device *hdev,
>                         case HID_DG_TIPSWITCH:
>                                 hid_data->last_slot_field =3D equivalent_=
usage;
>                                 break;
> +                       case HID_DG_CONTACTCOUNT:
> +                               hid_data->cc_report =3D report->id;
> +                               hid_data->cc_index =3D i;
> +                               hid_data->cc_value_index =3D j;
> +                               break;
>                         }
>                 }
>         }
> +
> +       if (hid_data->cc_report !=3D 0 &&
> +           hid_data->cc_index >=3D 0) {
> +               struct hid_field *field =3D report->field[hid_data->cc_in=
dex];
> +               int value =3D field->value[hid_data->cc_value_index];
> +               if (value)
> +                       hid_data->num_expected =3D value;
> +       }
> +       else {
> +               hid_data->num_expected =3D wacom_wac->features.touch_max;
> +       }
>  }
>
>  static void wacom_wac_finger_report(struct hid_device *hdev,
> @@ -2649,7 +2665,6 @@ static void wacom_wac_finger_report(struct hid_devi=
ce *hdev,
>         struct wacom_wac *wacom_wac =3D &wacom->wacom_wac;
>         struct input_dev *input =3D wacom_wac->touch_input;
>         unsigned touch_max =3D wacom_wac->features.touch_max;
> -       struct hid_data *hid_data =3D &wacom_wac->hid_data;
>
>         /* If more packets of data are expected, give us a chance to
>          * process them rather than immediately syncing a partial
> @@ -2663,7 +2678,6 @@ static void wacom_wac_finger_report(struct hid_devi=
ce *hdev,
>
>         input_sync(input);
>         wacom_wac->hid_data.num_received =3D 0;
> -       hid_data->num_expected =3D 0;
>
>         /* keep touch state for pen event */
>         wacom_wac->shared->touch_down =3D wacom_wac_finger_count_touches(=
wacom_wac);
> @@ -2738,73 +2752,12 @@ static void wacom_report_events(struct hid_device=
 *hdev,
>         }
>  }
>
> -static void wacom_set_num_expected(struct hid_device *hdev,
> -                                  struct hid_report *report,
> -                                  int collection_index,
> -                                  struct hid_field *field,
> -                                  int field_index)
> -{
> -       struct wacom *wacom =3D hid_get_drvdata(hdev);
> -       struct wacom_wac *wacom_wac =3D &wacom->wacom_wac;
> -       struct hid_data *hid_data =3D &wacom_wac->hid_data;
> -       unsigned int original_collection_level =3D
> -               hdev->collection[collection_index].level;
> -       bool end_collection =3D false;
> -       int i;
> -
> -       if (hid_data->num_expected)
> -               return;
> -
> -       // find the contact count value for this segment
> -       for (i =3D field_index; i < report->maxfield && !end_collection; =
i++) {
> -               struct hid_field *field =3D report->field[i];
> -               unsigned int field_level =3D
> -                       hdev->collection[field->usage[0].collection_index=
].level;
> -               unsigned int j;
> -
> -               if (field_level !=3D original_collection_level)
> -                       continue;
> -
> -               for (j =3D 0; j < field->maxusage; j++) {
> -                       struct hid_usage *usage =3D &field->usage[j];
> -
> -                       if (usage->collection_index !=3D collection_index=
) {
> -                               end_collection =3D true;
> -                               break;
> -                       }
> -                       if (wacom_equivalent_usage(usage->hid) =3D=3D HID=
_DG_CONTACTCOUNT) {
> -                               hid_data->cc_report =3D report->id;
> -                               hid_data->cc_index =3D i;
> -                               hid_data->cc_value_index =3D j;
> -
> -                               if (hid_data->cc_report !=3D 0 &&
> -                                   hid_data->cc_index >=3D 0) {
> -
> -                                       struct hid_field *field =3D
> -                                               report->field[hid_data->c=
c_index];
> -                                       int value =3D
> -                                               field->value[hid_data->cc=
_value_index];
> -
> -                                       if (value)
> -                                               hid_data->num_expected =
=3D value;
> -                               }
> -                       }
> -               }
> -       }
> -
> -       if (hid_data->cc_report =3D=3D 0 || hid_data->cc_index < 0)
> -               hid_data->num_expected =3D wacom_wac->features.touch_max;
> -}
> -
>  static int wacom_wac_collection(struct hid_device *hdev, struct hid_repo=
rt *report,
>                          int collection_index, struct hid_field *field,
>                          int field_index)
>  {
>         struct wacom *wacom =3D hid_get_drvdata(hdev);
>
> -       if (WACOM_FINGER_FIELD(field))
> -               wacom_set_num_expected(hdev, report, collection_index, fi=
eld,
> -                                      field_index);
>         wacom_report_events(hdev, report, collection_index, field_index);
>
>         /*
> --
> 2.26.0
>
