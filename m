Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC92C3595
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 15:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388316AbfJAN0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 09:26:40 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:34885 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388261AbfJAN0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 09:26:39 -0400
Received: by mail-io1-f52.google.com with SMTP id q10so47966356iop.2
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 06:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=pRBNRHcqqFdRJYVFRoZrLdwl8LWz7ur2lb7IaIzatzY=;
        b=sWv7k9iSxFF5kO237Rsy/t3sFSCofCHzsABShqPKm8zP7nU8FFG31c/44J/X+YFIAP
         nDE27jkCp3KlJBBTtlbSmcD1ljuHTfkSGFuV169LOKYiT1u1H+owDFJcA3/Vvqdd/KgQ
         HVEsci9oD49L4GdWtzFKdACIYrh5hz1tHEVOJ4QO03asZWEXOH6pdfEbKv1B0XeQf6zj
         oEUXDiLQoSNiq+Gn3soyl+Zt62FlXYSS3Fc8wYFImcMNSqvcfyYRttJBq8SB8y+5F7Ee
         jW2h+HFzMnCF0CWqe0KVQQ2KF1MgCyyK7vDlnljDCB9p7+/HprKTlNX6ksHu9H0y2KAi
         ycTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=pRBNRHcqqFdRJYVFRoZrLdwl8LWz7ur2lb7IaIzatzY=;
        b=sYzYwSyd+sQlUNUuGkoPlQ48qw+4VcFxQ6PNQnVHqvrHoV5QtSsEKEjrqTGBdpLDML
         kiURV5dUxs5+C8M0Qv5sKMFMMHL7Vn29GuTGbWbejthPh88sw15n5e8TsiCK7JCe/l5K
         e/dsBqC0p0mrVLl9Tb97J7Fiea305+j/NRqbNziGG7/Tl2IJRQ1oAIT4nO29G2TnWDgW
         QYLMoFTQA1SIQGSKuQQpsXoc6hA8/gw7JYltTzmpMi7hEVRm+vqxNlnp8oXVkhFlEBhf
         qm5jknKbjBEaCSHjU7jdGIV6dNU6u5G2grdXcZLiEFKFkVwtuB7IxQffalRAGLA8maK8
         bf2Q==
X-Gm-Message-State: APjAAAU7/N1Y/dNO4mUYJjVgGl96PR5TC47Pj/+z0QmIP4JlKGWW6JKD
        Hcb6cZn3ufIBR450MSb8o7S/cSfSRWcghtKMbKFT+dgbjJ4=
X-Google-Smtp-Source: APXvYqyvKWesQf99TyuCzMLtgkC/YfJiKGzkLidlrc6Z6yth6KIElqJ7VNFy8DABEPaqlfW9sHKqvMpzl44TxvBU0Gg=
X-Received: by 2002:a02:65cd:: with SMTP id u196mr24103539jab.3.1569936397458;
 Tue, 01 Oct 2019 06:26:37 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Ford <aford173@gmail.com>
Date:   Tue, 1 Oct 2019 08:26:26 -0500
Message-ID: <CAHCN7xL2f2R2KjPddZmmoBLSx_tkbNZ6R2tJ-j6tYmvLd856AA@mail.gmail.com>
Subject: ARM: dts: logicpd-torpedo-baseboard: Fix missing video
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply f9f5518a3868 ("ARM: dts: logicpd-torpedo-baseboard: Fix
missing video") to 5.2 and 5.3 stable branches.

This fixes an issue where video is lost due to the removal of a driver
and its replacement was not enabled.

Thank you,

adam
