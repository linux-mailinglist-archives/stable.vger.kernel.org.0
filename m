Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11FE014F2A2
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 20:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgAaTUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 14:20:32 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58803 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgAaTUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 14:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580498429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lXc2Kseit8eJLPRRmofyUjzMnZWq4b4tzDcpS+Uo2uQ=;
        b=DCUjFwBUzzZov1UzK8+dkyMuRSJ+u2LVWU1/p3ALl040Sl9FPvdWoksDPdFSoN2r/aL6hY
        oDhf/s3Qz8/oLB4xwcMwmVCTzE/eDJEZhoDuftEREs9SJbQKcWpCmA/dE+n5YUVJDKP4u6
        HaEiDAe0TA0Mq+xDELUKekDTpYQDpcI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-G68g7ZjzOcu7mNbKpfqXzA-1; Fri, 31 Jan 2020 14:20:20 -0500
X-MC-Unique: G68g7ZjzOcu7mNbKpfqXzA-1
Received: by mail-qv1-f69.google.com with SMTP id f17so5040009qvi.6
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 11:20:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lXc2Kseit8eJLPRRmofyUjzMnZWq4b4tzDcpS+Uo2uQ=;
        b=ev0rrgGfsZ4ONbpOt3LNhx8mTKBGmnGsU8tuofVNBjox9N87FeKOnFzSqktZyGseTt
         JLWl/TMeNFhpHWGVTkLbruyXCOFDdaUW4voE/npFwl5EJ+C6DW4yTAPVzyU5qEns/rQi
         QP8LNp9DSB0+8UnIaSfi/snB1mluuR5XSeQb8oVSK1E60vlF3ZBBCeL0/LnP5K5Z2+CZ
         PQRtAihw1+EqlUFKGVZojDhu9QkMpt4eoP4wPX29/p8kZ2HLv0SdHyIGJiWFSNmTHJQE
         +IOXEbkucqZ7SvVil5B7JsA46RjGEUPWzU9YkIB5cx6wxoDchtwVuyLrdAJF6Ik9ZQjE
         nLFQ==
X-Gm-Message-State: APjAAAVhqHnI1yfKGIN0JULedlpvPLjqkxh5cCwV+fgHjYg8UtY9V67m
        W3jbhgS0UCI1KvjS6f+bhyixUOVrNh/LWIkyBmn+pRl30Ki0e5Nk1THHzj1YQejWfJLikVsZoqd
        dUzZqTpwBxUwN+fQWDYNvPmCNw+0CXGLM
X-Received: by 2002:ac8:390a:: with SMTP id s10mr12173486qtb.31.1580498420123;
        Fri, 31 Jan 2020 11:20:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqzpTiRNFrTNFuDKRHLYnAVJ6spBbXzzjJG/Zzgm3VOefDM8Cq0clfVgr875OK2Md2IuQqRH3AQvRr9aQJ9f4GU=
X-Received: by 2002:ac8:390a:: with SMTP id s10mr12173452qtb.31.1580498419739;
 Fri, 31 Jan 2020 11:20:19 -0800 (PST)
MIME-Version: 1.0
References: <20200131124553.27796-1-hdegoede@redhat.com> <CAO-hwJK-wwZ8UJRaBgjVc0ZXakU9C3eDbh+i6Q5vm8xh1P76LQ@mail.gmail.com>
 <ea896405-6784-7cfd-b27c-28e8ebc3cd7e@redhat.com> <CAO-hwJJ1v30NT5quobYawV9yv87buyrQXOG9u-nY3zXXSrCGvg@mail.gmail.com>
 <6d94cf74-c28f-08b0-a136-044c231b8bc5@redhat.com> <CAO-hwJ+o5CvU3Pv+dQV2gSTeF+n0AGkjwYJvWfX_ZYtM=OtH6g@mail.gmail.com>
 <CABHH5-LmC3JOWyDoxC5hizZe6RZ6RuO=-gk8WDXvU9Z2usihXg@mail.gmail.com>
 <fa288cc2-0560-1fa5-a629-20a7a33afeb2@redhat.com> <CABHH5-KNv7TU6=fiMk3JDxEX2mx7y9qr0Qx9sjOL9-=Rd5jsMw@mail.gmail.com>
 <CAO-hwJ+QnjLu1-Q_KneyOnpc-QaedYUdJUJHH-0E=Txv3kqy5Q@mail.gmail.com>
 <CABHH5-+MQZgj+Wz-BdHLJbK7X2dyyAES6KJspR=gK0TO0Dk73A@mail.gmail.com>
 <CAO-hwJ+f=pyzS5U39LaYexy6gf2bRzr1_hgp5wxkW0b6uJwz7w@mail.gmail.com> <CABHH5-LQ_Y-LGeKQHyyp0Nbz6Gmxr2TOmTPBeZqeKYTD9t3ELQ@mail.gmail.com>
In-Reply-To: <CABHH5-LQ_Y-LGeKQHyyp0Nbz6Gmxr2TOmTPBeZqeKYTD9t3ELQ@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 31 Jan 2020 20:20:08 +0100
Message-ID: <CAO-hwJLUdaSp_Hi9+m4R542zZ_3X-a=m42PT2hZjCOeCZpReHg@mail.gmail.com>
Subject: Re: [PATCH] HID: ite: Only bind to keyboard USB interface on Acer
 SW5-012 keyboard dock
To:     Z R <zdenda.rampas@gmail.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 31, 2020 at 6:51 PM Z R <zdenda.rampas@gmail.com> wrote:
>
> libiniput record touchpad - with one small two finger scroll:
>
> root@debswitch:~# libinput record
> Available devices:
> /dev/input/event0:      Video Bus
> /dev/input/event1:      Acer WMI hotkeys
> /dev/input/event2:      SYNA7508:00 06CB:10EB
> /dev/input/event3:      SYNA7508:00 06CB:10EB
> /dev/input/event4:      ITE Tech. Inc. ITE Device(8595) Keyboard
> /dev/input/event5:      ITE Tech. Inc. ITE Device(8595) Consumer Control
> /dev/input/event6:      ITE Tech. Inc. ITE Device(8595) Wireless Radio Control
> /dev/input/event7:      ITE Tech. Inc. ITE Device(8595)
> /dev/input/event8:      ITE Tech. Inc. ITE Device(8595) System Control
> /dev/input/event9:      PC Speaker
> /dev/input/event10:     ITE Tech. Inc. ITE Device(8595) Mouse
> /dev/input/event11:     Intel HDMI/DP LPE Audio HDMI/DP,pcm=0
> /dev/input/event12:     Intel HDMI/DP LPE Audio HDMI/DP,pcm=1
> /dev/input/event13:     SYNA7508:00 06CB:10EB Mouse
> /dev/input/event14:     ITE Tech. Inc. ITE Device(8595) Touchpad
> /dev/input/event15:     gpio-keys
> /dev/input/event16:     gpio-keys
> /dev/input/event17:     bytcr-rt5640 Headset
> Select the device event number: 14
> Recording to 'stdout'.
> version: 1
> ndevices: 1
> libinput:
>   version: "1.12.6"
>   git: "unknown"
> system:
>   kernel: "5.5.0-vanilla+switch+revert8f18eca-debconf55rc5"
>   dmi: "dmi:bvnINSYDECorp.:bvrV1.20:bd03/01/2016:svnAcer:pnAspireSW5-012:pvrV1.20:rvnAcer:rnFendi2:rvrV1.20:cvnAcer:ct10:cvrChassisVersion:"
> devices:
> - node: /dev/input/event14
>   evdev:
>     # Name: ITE Tech. Inc. ITE Device(8595) Touchpad
>     # ID: bus 0x3 vendor 0x6cb product 0x2968 version 0x110
>     # Size in mm: 87x47
>     # Supported Events:
>     # Event type 0 (EV_SYN)
>     # Event type 1 (EV_KEY)
>     #   Event code 272 (BTN_LEFT)
>     #   Event code 325 (BTN_TOOL_FINGER)
>     #   Event code 330 (BTN_TOUCH)
>     #   Event code 333 (BTN_TOOL_DOUBLETAP)
>     #   Event code 334 (BTN_TOOL_TRIPLETAP)
>     # Event type 3 (EV_ABS)
>     #   Event code 0 (ABS_X)
>     #       Value         237
>     #       Min             0
>     #       Max          1051
>     #       Fuzz            0
>     #       Flat            0
>     #       Resolution     12
>     #   Event code 1 (ABS_Y)
>     #       Value         166
>     #       Min             0
>     #       Max           571
>     #       Fuzz            0
>     #       Flat            0
>     #       Resolution     12
>     #   Event code 47 (ABS_MT_SLOT)
>     #       Value           0
>     #       Min             0
>     #       Max             2

Thanks!, that means you have only up to 2 fingers that can be reported.

FYI, first PR: https://gitlab.freedesktop.org/libevdev/hid-tools/merge_requests/69
(I need to update it with this max_contact information)

Still working on the hid-ite.c regression tests.

Cheers,
Benjamin

>     #       Fuzz            0
>     #       Flat            0
>     #       Resolution      0
>     #   Event code 53 (ABS_MT_POSITION_X)
>     #       Value           0
>     #       Min             0
>     #       Max          1051
>     #       Fuzz            0
>     #       Flat            0
>     #       Resolution     12
>     #   Event code 54 (ABS_MT_POSITION_Y)
>     #       Value           0
>     #       Min             0
>     #       Max           571
>     #       Fuzz            0
>     #       Flat            0
>     #       Resolution     12
>     #   Event code 55 (ABS_MT_TOOL_TYPE)
>     #       Value           0
>     #       Min             0
>     #       Max             2
>     #       Fuzz            0
>     #       Flat            0
>     #       Resolution      0
>     #   Event code 57 (ABS_MT_TRACKING_ID)
>     #       Value           0
>     #       Min             0
>     #       Max         65535
>     #       Fuzz            0
>     #       Flat            0
>     #       Resolution      0
>     # Event type 4 (EV_MSC)
>     #   Event code 5 (MSC_TIMESTAMP)
>     # Properties:
>     #    Property 0 (INPUT_PROP_POINTER)
>     #    Property 2 (INPUT_PROP_BUTTONPAD)
>     name: "ITE Tech. Inc. ITE Device(8595) Touchpad"
>     id: [3, 1739, 10600, 272]
>     codes:
>       0: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] # EV_SYN
>       1: [272, 325, 330, 333, 334] # EV_KEY
>       3: [0, 1, 47, 53, 54, 55, 57] # EV_ABS
>       4: [5] # EV_MSC
>     absinfo:
>       0: [0, 1051, 0, 0, 12]
>       1: [0, 571, 0, 0, 12]
>       47: [0, 2, 0, 0, 0]
>       53: [0, 1051, 0, 0, 12]
>       54: [0, 571, 0, 0, 12]
>       55: [0, 2, 0, 0, 0]
>       57: [0, 65535, 0, 0, 0]
>     properties: [0, 2]
>   udev:
>     properties:
>     - ID_INPUT=1
>     - ID_INPUT_HEIGHT_MM=47
>     - ID_INPUT_TOUCHPAD=1
>     - ID_INPUT_TOUCHPAD_INTEGRATION=internal
>     - ID_INPUT_WIDTH_MM=87
>     - LIBINPUT_DEVICE_GROUP=3/6cb/2968:usb-0000:00:14.0-1
>   quirks:
>   events:
>   - evdev:
>     - [  0,      0,   3,  57,    80] # EV_ABS / ABS_MT_TRACKING_ID     80
>     - [  0,      0,   3,  53,   608] # EV_ABS / ABS_MT_POSITION_X     608
>     - [  0,      0,   3,  54,   255] # EV_ABS / ABS_MT_POSITION_Y     255
>     - [  0,      0,   1, 330,     1] # EV_KEY / BTN_TOUCH               1
>     - [  0,      0,   1, 325,     1] # EV_KEY / BTN_TOOL_FINGER         1
>     - [  0,      0,   3,   0,   608] # EV_ABS / ABS_X                 608
>     - [  0,      0,   3,   1,   255] # EV_ABS / ABS_Y                 255
>     - [  0,      0,   4,   5,     0] # EV_MSC / MSC_TIMESTAMP           0
>     - [  0,      0,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +0ms
>   - evdev:
>     - [  0,   9967,   3,  47,     1] # EV_ABS / ABS_MT_SLOT             1
>     - [  0,   9967,   3,  57,    81] # EV_ABS / ABS_MT_TRACKING_ID     81
>     - [  0,   9967,   3,  53,   326] # EV_ABS / ABS_MT_POSITION_X     326
>     - [  0,   9967,   3,  54,   324] # EV_ABS / ABS_MT_POSITION_Y     324
>     - [  0,   9967,   3,  47,     0] # EV_ABS / ABS_MT_SLOT             0
>     - [  0,   9967,   3,  53,   614] # EV_ABS / ABS_MT_POSITION_X     614
>     - [  0,   9967,   3,  54,   250] # EV_ABS / ABS_MT_POSITION_Y     250
>     - [  0,   9967,   1, 325,     0] # EV_KEY / BTN_TOOL_FINGER         0
>     - [  0,   9967,   1, 333,     1] # EV_KEY / BTN_TOOL_DOUBLETAP      1
>     - [  0,   9967,   3,   0,   614] # EV_ABS / ABS_X                 614
>     - [  0,   9967,   3,   1,   250] # EV_ABS / ABS_Y                 250
>     - [  0,   9967,   4,   5,  7200] # EV_MSC / MSC_TIMESTAMP        7200
>     - [  0,   9967,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +9ms
>   - evdev:
>     - [  0,  16723,   3,  47,     1] # EV_ABS / ABS_MT_SLOT             1
>     - [  0,  16723,   3,  53,   323] # EV_ABS / ABS_MT_POSITION_X     323
>     - [  0,  16723,   3,  54,   309] # EV_ABS / ABS_MT_POSITION_Y     309
>     - [  0,  16723,   3,  47,     0] # EV_ABS / ABS_MT_SLOT             0
>     - [  0,  16723,   3,  53,   612] # EV_ABS / ABS_MT_POSITION_X     612
>     - [  0,  16723,   3,  54,   240] # EV_ABS / ABS_MT_POSITION_Y     240
>     - [  0,  16723,   3,   0,   612] # EV_ABS / ABS_X                 612
>     - [  0,  16723,   3,   1,   240] # EV_ABS / ABS_Y                 240
>     - [  0,  16723,   4,   5, 14500] # EV_MSC / MSC_TIMESTAMP        14500
>     - [  0,  16723,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +7ms
>   - evdev:
>     - [  0,  24982,   3,  47,     1] # EV_ABS / ABS_MT_SLOT             1
>     - [  0,  24982,   3,  53,   321] # EV_ABS / ABS_MT_POSITION_X     321
>     - [  0,  24982,   3,  54,   294] # EV_ABS / ABS_MT_POSITION_Y     294
>     - [  0,  24982,   3,  47,     0] # EV_ABS / ABS_MT_SLOT             0
>     - [  0,  24982,   3,  53,   614] # EV_ABS / ABS_MT_POSITION_X     614
>     - [  0,  24982,   3,  54,   228] # EV_ABS / ABS_MT_POSITION_Y     228
>     - [  0,  24982,   3,   0,   614] # EV_ABS / ABS_X                 614
>     - [  0,  24982,   3,   1,   228] # EV_ABS / ABS_Y                 228
>     - [  0,  24982,   4,   5, 21900] # EV_MSC / MSC_TIMESTAMP        21900
>     - [  0,  24982,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +8ms
>   - evdev:
>     - [  0,  32006,   3,  47,     1] # EV_ABS / ABS_MT_SLOT             1
>     - [  0,  32006,   3,  53,   320] # EV_ABS / ABS_MT_POSITION_X     320
>     - [  0,  32006,   3,  54,   286] # EV_ABS / ABS_MT_POSITION_Y     286
>     - [  0,  32006,   3,  47,     0] # EV_ABS / ABS_MT_SLOT             0
>     - [  0,  32006,   3,  54,   220] # EV_ABS / ABS_MT_POSITION_Y     220
>     - [  0,  32006,   3,   1,   220] # EV_ABS / ABS_Y                 220
>     - [  0,  32006,   4,   5, 29200] # EV_MSC / MSC_TIMESTAMP        29200
>     - [  0,  32006,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +8ms
>   - evdev:
>     - [  0,  38703,   3,  47,     1] # EV_ABS / ABS_MT_SLOT             1
>     - [  0,  38703,   3,  53,   317] # EV_ABS / ABS_MT_POSITION_X     317
>     - [  0,  38703,   3,  54,   276] # EV_ABS / ABS_MT_POSITION_Y     276
>     - [  0,  38703,   3,  47,     0] # EV_ABS / ABS_MT_SLOT             0
>     - [  0,  38703,   3,  54,   215] # EV_ABS / ABS_MT_POSITION_Y     215
>     - [  0,  38703,   3,   1,   215] # EV_ABS / ABS_Y                 215
>     - [  0,  38703,   4,   5, 36400] # EV_MSC / MSC_TIMESTAMP        36400
>     - [  0,  38703,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +6ms
>   - evdev:
>     - [  0,  46798,   3,  47,     1] # EV_ABS / ABS_MT_SLOT             1
>     - [  0,  46798,   3,  53,   315] # EV_ABS / ABS_MT_POSITION_X     315
>     - [  0,  46798,   3,  54,   268] # EV_ABS / ABS_MT_POSITION_Y     268
>     - [  0,  46798,   3,  47,     0] # EV_ABS / ABS_MT_SLOT             0
>     - [  0,  46798,   3,  54,   207] # EV_ABS / ABS_MT_POSITION_Y     207
>     - [  0,  46798,   3,   1,   207] # EV_ABS / ABS_Y                 207
>     - [  0,  46798,   4,   5, 43700] # EV_MSC / MSC_TIMESTAMP        43700
>     - [  0,  46798,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +8ms
>   - evdev:
>     - [  0,  53969,   3,  47,     1] # EV_ABS / ABS_MT_SLOT             1
>     - [  0,  53969,   3,  53,   313] # EV_ABS / ABS_MT_POSITION_X     313
>     - [  0,  53969,   3,  54,   258] # EV_ABS / ABS_MT_POSITION_Y     258
>     - [  0,  53969,   3,  47,     0] # EV_ABS / ABS_MT_SLOT             0
>     - [  0,  53969,   3,  54,   201] # EV_ABS / ABS_MT_POSITION_Y     201
>     - [  0,  53969,   3,   1,   201] # EV_ABS / ABS_Y                 201
>     - [  0,  53969,   4,   5, 50900] # EV_MSC / MSC_TIMESTAMP        50900
>     - [  0,  53969,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +7ms
>   - evdev:
>     - [  0,  60969,   3,  47,     1] # EV_ABS / ABS_MT_SLOT             1
>     - [  0,  60969,   3,  53,   312] # EV_ABS / ABS_MT_POSITION_X     312
>     - [  0,  60969,   3,  54,   255] # EV_ABS / ABS_MT_POSITION_Y     255
>     - [  0,  60969,   3,  47,     0] # EV_ABS / ABS_MT_SLOT             0
>     - [  0,  60969,   3,  54,   197] # EV_ABS / ABS_MT_POSITION_Y     197
>     - [  0,  60969,   3,   1,   197] # EV_ABS / ABS_Y                 197
>     - [  0,  60969,   4,   5, 58100] # EV_MSC / MSC_TIMESTAMP        58100
>     - [  0,  60969,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +7ms
>   - evdev:
>     - [  0,  69142,   3,  47,     1] # EV_ABS / ABS_MT_SLOT             1
>     - [  0,  69142,   3,  53,   310] # EV_ABS / ABS_MT_POSITION_X     310
>     - [  0,  69142,   3,  54,   251] # EV_ABS / ABS_MT_POSITION_Y     251
>     - [  0,  69142,   3,  47,     0] # EV_ABS / ABS_MT_SLOT             0
>     - [  0,  69142,   3,  54,   193] # EV_ABS / ABS_MT_POSITION_Y     193
>     - [  0,  69142,   3,   1,   193] # EV_ABS / ABS_Y                 193
>     - [  0,  69142,   4,   5, 65400] # EV_MSC / MSC_TIMESTAMP        65400
>     - [  0,  69142,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +9ms
>   - evdev:
>     - [  0,  76007,   3,  47,     1] # EV_ABS / ABS_MT_SLOT             1
>     - [  0,  76007,   3,  54,   246] # EV_ABS / ABS_MT_POSITION_Y     246
>     - [  0,  76007,   3,  47,     0] # EV_ABS / ABS_MT_SLOT             0
>     - [  0,  76007,   3,  53,   613] # EV_ABS / ABS_MT_POSITION_X     613
>     - [  0,  76007,   3,   0,   613] # EV_ABS / ABS_X                 613
>     - [  0,  76007,   4,   5, 72600] # EV_MSC / MSC_TIMESTAMP        72600
>     - [  0,  76007,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +7ms
>   - evdev:
>     - [  0,  83070,   3,  47,     1] # EV_ABS / ABS_MT_SLOT             1
>     - [  0,  83070,   3,  54,   241] # EV_ABS / ABS_MT_POSITION_Y     241
>     - [  0,  83070,   3,  47,     0] # EV_ABS / ABS_MT_SLOT             0
>     - [  0,  83070,   3,  54,   192] # EV_ABS / ABS_MT_POSITION_Y     192
>     - [  0,  83070,   3,   1,   192] # EV_ABS / ABS_Y                 192
>     - [  0,  83070,   4,   5, 79900] # EV_MSC / MSC_TIMESTAMP        79900
>     - [  0,  83070,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +7ms
>   - evdev:
>     - [  0,  89724,   3,  47,     1] # EV_ABS / ABS_MT_SLOT             1
>     - [  0,  89724,   3,  57,    -1] # EV_ABS / ABS_MT_TRACKING_ID     -1
>     - [  0,  89724,   3,  47,     0] # EV_ABS / ABS_MT_SLOT             0
>     - [  0,  89724,   3,  57,    -1] # EV_ABS / ABS_MT_TRACKING_ID     -1
>     - [  0,  89724,   1, 330,     0] # EV_KEY / BTN_TOUCH               0
>     - [  0,  89724,   1, 333,     0] # EV_KEY / BTN_TOOL_DOUBLETAP      0
>     - [  0,  89724,   4,   5, 87100] # EV_MSC / MSC_TIMESTAMP        87100
>     - [  0,  89724,   0,   0,     0] # ------------ SYN_REPORT (0) ---------- +6ms
>                                      # Touch device in neutral state
>

