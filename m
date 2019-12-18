Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A95123BBA
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 01:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfLRAmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 19:42:54 -0500
Received: from mail-pj1-f42.google.com ([209.85.216.42]:51009 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfLRAmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 19:42:54 -0500
Received: by mail-pj1-f42.google.com with SMTP id r67so46004pjb.0
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 16:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+//x3dkyOZdRcFW8AHZb55TeITv0chbwg57akwX1YGg=;
        b=FTywXrWwcX2gwvUdjo4puYlvFM1s9hEjAey1kfvK03Yx+GCmiXtmt+4JT91stJyt+v
         vXdMNqXYvD5HYb1yMQGdfNL0cFKGMAXwbLJ0FY9n1AtYloN1oK5or6AeiEl3BmAjt/iP
         2st6IdIu7IdLX2cMI7qIcTtaIkWc8CuIvxWXWClafGrjz/Y5THVtt4Y0e3hUklWi/Wue
         n+GfN/L6Y9EEv/kZfOI4F5MQMquQfSGVHiNlpd+IYnetv004xKK5d4nAlOci0VX44xs+
         gEGn/cC/ymYqwlGJNJtEgFaJg5NnllF/tmbK5hl93GuKbV2Gd4yD1THQDegG0QRf7rtM
         pZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=+//x3dkyOZdRcFW8AHZb55TeITv0chbwg57akwX1YGg=;
        b=NnNXCOsluF01IuecPNwr2olJHOnK20fMm5EKVoMkeCYmTqvkOaUV3g1oeqdxrOwoOs
         yjNjJMORC/bad9xn8eZ+NguLfxA9x8NyL7G6rGBhnAIY0Fob+PneZdzE++Xr29IWk8MC
         aKv9J2lCQ0WZ9gsBPrBIUPzbaOuTOtB2Wu6DZMNqMVVZWxuOIT0oIHeXTxUu7//wDJgF
         PKZHmFKjuYiyIgJT/7BounctV+y1BpYmDPQpSnvZ69G6nN7dhYQkuBPAVWqIKYcTizz/
         4l9PKVlW5QAh4NUWZ9h10aSrmhx1o4VC78Q28LwPb3SfklaXuopEykDkfdE4PZpikgMf
         2bIA==
X-Gm-Message-State: APjAAAWpDorPEEsBzLNM6ssLUHGv2Y0XbvEOvaAzSWEfs0kTE3VyMR/O
        yVSLDvnTKNDHzkEbEaOEPxI=
X-Google-Smtp-Source: APXvYqxIjRuHyEMZhFsSM9pGDyQS+2+fonb9fBb9IjFk2GRLG0FiP0ulzaHoxoG+2q4EkeyzMvmBgQ==
X-Received: by 2002:a17:902:b588:: with SMTP id a8mr1010793pls.81.1576629773315;
        Tue, 17 Dec 2019 16:42:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g9sm240916pfm.150.2019.12.17.16.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 16:42:52 -0800 (PST)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Please apply commit e9a9853c23c13a3 ("nvme: host: core: fix
 precedence of ternary operator") to v4.9.y and v4.14.y
Message-ID: <4cbbe4b0-43c0-a365-e94d-0b34ac5a6dea@roeck-us.net>
Date:   Tue, 17 Dec 2019 16:42:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Commit e9a9853c23c13a3 ("nvme: host: core: fix precedence of ternary operator")
fixes a real bug and should be applied to v4.9.y and v4.14.y.

Thanks,
Guenter
